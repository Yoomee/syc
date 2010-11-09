require 'forwardable'
class Photo < ActiveRecord::Base

  extend Forwardable
  include Media
  include TramlinesImages
  
  search_attributes %w{name description}

  after_create :resize_down

  belongs_to :photo_album
  alias_attribute :album, :photo_album #, :auto_save => true
  
  before_validation :create_album_if_needed

  # Shouldn't validate image file size, as it will be sized down after creation
  validates_presence_of :photo_album
  
  named_scope :system_photos, :joins => :photo_album, :conditions => {:photo_albums => {:system_album => true}}
  
  attr_accessor :system_photo
  alias_method :system_photo?, :system_photo

  def_delegator :image, :url

  def validate
    if has_image?
      true
    else
      errors.add(:image, "was not selected")
      false
    end
  end
  
  private
  def create_album_if_needed
    self.build_photo_album(:system_album => system_photo) unless album
  end

  def resize_down
    self.image = image.process!(:resize, :geometry => APP_CONFIG[:photo_resize_geometry])
    save!
  end
  
end
