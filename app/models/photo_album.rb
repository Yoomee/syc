class PhotoAlbum < ActiveRecord::Base

  UNTITLED_NAME = "Untitled Album"
  
  belongs_to :attachable, :polymorphic => true
  has_many :photos, :dependent => :destroy
  
  before_validation :set_name_as_untitled

  named_scope :non_system, :conditions => {:system_album => false}
  named_scope :system_albums, :conditions => {:system_album => true}
  named_scope :untitled, :conditions => "name LIKE '#{UNTITLED_NAME}%'"
  named_scope :without_attachable, :conditions => {:attachable_id => nil}
  
  validates_presence_of :name
  
  def member
    attachable.is_a?(Member) ? attachable : nil
  end
  
  def owner?(member)
    member && self.member==member
  end
  
  def to_s
    name
  end
  
  private
  # TODO: check that this works correctly when creating a member's first photo_album from photos/new
  def set_name_as_untitled
    if name.blank?
      untitled_count = attachable ? attachable.photo_albums.untitled.size : self.class.without_attachable.untitled.size
      self.name = "#{UNTITLED_NAME} #{untitled_count + 1}"
    end
    true
  end
  
end
