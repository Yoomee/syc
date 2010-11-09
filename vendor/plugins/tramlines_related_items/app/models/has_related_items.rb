module HasRelatedItems
  
  def self.included(klass)
    klass.has_many :item_relationships, :as => :item, :dependent => :destroy, :autosave => true
    klass.accepts_nested_attributes_for :item_relationships, :allow_destroy => true
    klass.has_many_polymorphs :related_items, :from             => klass.send(:class_variable_get, '@@related_models'),
                                              :through          => :item_relationships,
                                              :as               => :item,
                                              :foreign_key      => :item_id,
                                              :foreign_type_key => :item_type,
                                              :rename_individual_collections => true
    klass.send(:alias_method_chain, :method_missing, :related_items)
    # The Rails built-in way isn't working, so:
    klass.after_save :destroy_marked_item_relationships
    
  end
  
  def has_related_items?
    !related_items.count.zero?
  end
  
  def method_missing_with_related_items(method_id, *args)
    method_name = method_id.to_s
    if match = method_name.match(/^related_(\w+)/)
      return send("related_item_#{match[1]}") unless match[1].match(/^item/)
    end
    method_missing_without_related_items(method_id, *args)
  end
  
  def destroy_marked_item_relationships
    item_relationships.select(&:marked_for_destruction?).each &:destroy
  end
  
end