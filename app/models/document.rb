
class Document < ActiveRecord::Base
  Document::CONTEXTS = %w{page primary secondary}

  named_scope :for_page, :conditions => { :context => 'page' }, :order =>  :name
  named_scope :for_primary, :conditions => { :context => 'primary' }, :order =>  :name
  named_scope :for_secondary, :conditions => { :context => 'secondary' }, :order =>  :name
  named_scope :ordered_by_name, :order => "name ASC"
  named_scope :without_folder, :conditions => "documents.folder_id IS NULL OR documents.folder_id = ''"

  search_attributes %w{name file_name}

  belongs_to :folder, :class_name => "DocumentFolder"
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
