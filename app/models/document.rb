class Document < ActiveRecord::Base

  search_attributes %w{name file_name}

  belongs_to :member

  attachment_accessor :file
  validates_presence_of :file
  validates_size_of :file, :maximum => 1.megabyte, :allow_blank => true
  
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
