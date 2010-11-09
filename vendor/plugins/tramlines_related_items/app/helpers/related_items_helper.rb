module RelatedItemsHelper
  
  def render_related_items(object, options = {})
    options[:image_size] ||= "145x90#"
    options[:limit] ||= 3
    related_items = object.related_items.limit(options[:limit])
    render :partial => "related_items/related_items", :locals => {:related_items => related_items}.merge(options)
  end
  
  def render_related_items_form(object)
    render :partial => "related_items/form", :locals => {:object => object}
  end
  
end