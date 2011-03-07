module TramlinesImages
  
  def self.included(klass)
    klass.cattr_accessor :image_attributes
    klass.image_attributes = klass.column_names.select {|col| col.match(/^.+_uid$/)}
    klass.image_attributes.each do |image_attr|
      if klass.respond_to?(:table_name)
        klass.send(:named_scope, "with_#{image_attr.gsub('_uid', '')}", :conditions => "#{klass.table_name}.#{image_attr} IS NOT NULL AND #{klass.table_name}.#{image_attr} != ''")
      end
      klass.image_accessor(image_attr.gsub('_uid', ''))
      klass.send(:validates_property, :mime_type, :of => image_attr.gsub('_uid', ''), :in => %w(image/jpeg image/png image/gif), :message => "must be an image")
    end
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
    
    def default_image(image_attr = 'image')
      Dragonfly::App[:images].fetch(default_image_location(image_attr))
    end

    def default_image_location(image_attr = 'image')
      default_filename = "#{self.to_s.underscore}_#{image_attr.to_s.gsub('_uid', '')}"
      File.exists?("#{RAILS_ROOT}/client/public/dragonfly/defaults/#{default_filename}") ? "client_defaults/#{default_filename}" : "defaults/#{default_filename}"
    end
    
  end
  
  def default_image(image_attr='image')
    self.class::default_image(image_attr)
  end
  
end