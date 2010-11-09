class Status < ActiveRecord::Base

  belongs_to :member
  
  validates_presence_of :member
  validates_presence_of :text
  validates_length_of :text, :maximum => 200
  
  add_to_news_feed
  
  named_scope :latest, :order => "created_at DESC"

  delegate :image, :to => :member

end
