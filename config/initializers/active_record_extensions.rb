class ActiveRecord::Base
  
  include ValidateExtensions
  
  named_scope :limit, lambda{|limit| {:limit => limit}}
  named_scope :latest, :order => "created_at DESC"
  named_scope :random, :order => "RAND()"
  
  class << self
    
    # TODO: extend image_accessor method so that a default image can automatically be used for dragonfly with the name of the model e.g defaults/member
    # def image_accessor_with_default(attribute)
    #   define_method("#{attribute}_uid") do |attribute|
    #     read_attribute("#{attribute}_uid").blank? ? "defaults/#{self.class.to_s.underscore}" : read_attribute("#{attribute}_uid")
    #   end
    #   image_accessor_without_default(attribute)
    # end
    # alias_method_chain :image_accessor, :default
  
    def add_to_news_feed(options = {})
      include AddToNewsFeed
      self.news_feed_actions = options[:only] || %w{create update}
      self.on_news_feed_attributes = options[:on_attributes] || []
      self.except_news_feed_attributes = options[:except_attributes] || []
      self.news_feed_weighting = options[:weighting] || 1
    end
    
    def formatted_time_accessor(*names)
      names.each do |name|
        define_method("formatted_#{name}") do
          self[name].in_time_zone.strftime('%d/%m/%Y %H:%M')
        end
        define_method("formatted_#{name}=") do |value|
          # datetime = DateTime.strptime(value, '%d/%m/%Y %H:%M').to_time
          self[name] = Time.zone.parse(value.gsub('/', '-'))
        end
      end
    end
    
    def has_virtual_attributes(*names)
      names.each do |name|
        define_method("attributes_with_#{name}") do
          returning out = send("attributes_without_#{name}") do
            out[name.to_s] = send(name)
          end
        end
        alias_method_chain :attributes, name
      end
    end
    alias_method :has_virtual_attribute, :has_virtual_attributes
    
    def search_attributes(attributes, options = {})
      attributes = [*attributes]
      options[:delta] = true if options[:delta].nil?
      options[:autocomplete] = true if options[:autocomplete].nil?
      send('define_index') do
        attributes.each {|a| indexes a}
        set_property :delta => options[:delta]
      end
      if options[:autocomplete]
        send('define_index', "autocomplete_#{self.to_s.pluralize.downcase}") do
          indexes attributes.first
          set_property :delta => options[:delta]
        end
      end
      # The summary fields default to being the search_attributes with the first excluded - if something different is required, it can be overwritten in the model
      define_method(:summary_fields) do
        attributes - [attributes.first]
      end
    end
    
  end
  
  def has_image?(image_attr = 'image_uid')
    # return false if self.class::included_modules.include?(TramlinesImages)
    image_attr = image_attr.to_s
    image_attr = "#{image_attr}_uid" unless image_attr.match(/_uid$/)
    !read_attribute(image_attr).blank?
  end
  
  def is_media?
    self.class.included_modules.include?(Media)
  end
  
  def owned_by?(member)
    return (self == member) if self.is_a?(Member)    
    return false if !respond_to?(:member)
    self.member == member
  end
  
end

class ActiveRecord::Migration
  
  class_inheritable_accessor :filename
  
  class << self
    
    def announce(message)
      text = "#{@version} #{name} (#{filename.gsub(/^#{RAILS_ROOT}\//, '')}): #{message}"
      length = [0, 75 - text.length].max
      write "== %s %s" % [text, "=" * length]
    end
    
  end
  
end

class ActiveRecord::MigrationProxy
  
  private
  def load_migration_with_filename_setting
    returning out = load_migration_without_filename_setting do
      out.filename = filename
    end
  end
  alias_method_chain :load_migration, :filename_setting
  
end

class ActiveRecord::Migrator
    
  def migrations_with_tramlines_paths
    @migrations_with_tramlines_paths ||= begin
      tramlines_migrations_paths.inject([]) do |memo, path|
        @migrations = nil
        @migrations_path = path
        memo + migrations_without_tramlines_paths
      end
    end
  end
  alias_method_chain :migrations, :tramlines_paths
  
  def tramlines_migrations_paths
    @tramlines_migrations_paths ||= ["#{RAILS_ROOT}/db/migrate", "#{RAILS_ROOT}/client/db/migrate"] + tramlines_plugin_migrations_paths
  end
  
  def tramlines_plugin_migrations_paths
    Dir["#{RAILS_ROOT}/vendor/plugins/tramlines_*/db/migrate"]
  end
  
end

# Fix for destroying new records which use thinking sphinx
module ThinkingSphinx::ActiveRecord
  
  def sphinx_document_id_with_destroy_fix
    new_record? ? 0 : sphinx_document_id_without_destroy_fix
  end
  alias_method_chain :sphinx_document_id, :destroy_fix
  
end