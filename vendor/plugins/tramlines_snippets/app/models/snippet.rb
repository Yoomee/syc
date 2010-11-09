class Snippet < ActiveRecord::Base
  
  belongs_to :item, :polymorphic => true
  validates_uniqueness_of :name, :scope => [:item_id, :item_type], :unless => Proc.new{|snippet| snippet.item_id.nil? || snippet.item_type.blank?}

  # before_save :set_item_delta_flag
  # 
  # private
  # def set_item_delta_flag
  #   if item.respond_to?(:delta)
  #     item.skip_save_snippets = true
  #     item.delta = true
  #     item.save
  #   end
  # end

end
