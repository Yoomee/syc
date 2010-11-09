class NewsFeedItem < ActiveRecord::Base
  
  default_scope :order => "created_at DESC"
  
  belongs_to :attachable, :polymorphic => true
  belongs_to :member
  
  def attachable_name
    if attachable.respond_to?(:name)
      attachable.name
    elsif attachable.respond_to?(:title)
      attachable.title
    end
  end
  
  def member_with_attachable
    return member_without_attachable unless member_without_attachable.nil?
    attachable.member if attachable.respond_to?(:member)
  end
  alias_method_chain :member, :attachable
  
  def partial_name
    "#{attachable_type.underscore}_news_feed_item"
  end
  
end