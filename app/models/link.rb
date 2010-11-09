class Link < ActiveRecord::Base
  
  include Media
  include TramlinesImages

  search_attributes %w{name url title description}
  
  before_save :revert_url_error_if_url_unchanged
  
  validates_presence_of :url
  validates_url_format_of :url
  
  has_many :photo_albums, :as => :attachable, :dependent => :destroy

  attr_accessor :url_changed
  alias_method :url_changed?, :url_changed

  def name
    read_attribute(:name).blank? ? url.gsub(/https?:\/\//, '') : read_attribute(:name)    
  end
  
  def url=(value)
    value = 'http://' + value unless value.blank? || value =~ /^http/
    write_attribute(:url, value)
    self.url_changed = changed.include?('url')
  end

  def summary_fields
    [:description]
  end
  
  private
  def revert_url_error_if_url_unchanged
    self.url_error = url_error_was if !url_changed?
    true
  end
  
end