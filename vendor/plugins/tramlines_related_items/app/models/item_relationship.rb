class ItemRelationship < ActiveRecord::Base
  
  belongs_to :item, :polymorphic => true
  belongs_to :related_item, :polymorphic => true
  
end