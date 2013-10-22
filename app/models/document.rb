
class Document < ActiveRecord::Base
  Document::CONTEXTS = %w{pages primary secondary}

  named_scope :for_pages, :conditions => { :context => 'page' }
  named_scope :for_primary, :conditions => { :context => 'primary' }
  named_scope :for_secondary, :conditions => { :context => 'secondary' }

  search_attributes %w{name file_name}

  belongs_to :member

  attachment_accessor :file
  validates_presence_of :file, :context
  validates_size_of :file, :maximum => 10.megabyte, :allow_blank => true
  validates_inclusion_of :context, :in => Document::CONTEXTS
  
  def name
    read_attribute(:name).blank? ? file_name : read_attribute(:name)
  end

  def path_to_file
    "#{RAILS_ROOT}/public#{url_for_file}"
  end

  def to_s
    name
  end

  def url_for_file
    file.url :format => file_ext
  end
  
end
