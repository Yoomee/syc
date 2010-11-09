module Ckeditor::FormHelper

  def photo_browser_button_tag(object_name, method, options = {})
    returning out = '' do
      target = "#{object_name}_#{method}"
      preview = photo_button_preview(object_name, method, options[:preview_html] || {})
      out << preview
      clear_options = {:class => 'photo_browser_clear', 'data-target' => target, :id => "#{target}_clear"}
      clear_options[:style] = "display: none;" if value(object_name, method, options).blank?
      out << content_tag(:span, "Clear", clear_options)
      out << button_tag("Select photo...", :class => 'photo_browser_button', 'data-target' => target)
      out << hidden_field(object_name, "#{method}_id")
    end
  end
  
  private
  def button_tag(name, options = {})
    options.reverse_merge!({:type => 'button', :value => name})
    content_tag(:input, '', options)
  end
  
  def photo_button_preview(object_name, method, options = {})
    ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_photo_button_preview_tag(options)
  end
  
  def value(object_name, method, options)
    #instance_variable_get("@#{object_name}").send(method)
    it = ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object))
    it.value(it.object)
  end
  
end

ActionView::Helpers::InstanceTag.class_eval do
  
  include ActionView::Helpers::AssetTagHelper
  include ImageHelper
  
  def to_photo_button_preview_tag(options = {})
    options = options.merge(:id => "#{sanitized_object_name}_#{sanitized_method_name}_preview", :class => "photo_button_preview")
    img_content = (val = value_before_type_cast(object)) ? image_for(val, TramlinesCkeditor::IMAGE_PREVIEW_SIZE) : ''
    content_tag(:div, img_content, options)
  end
  
end

ActionView::Helpers::FormBuilder.class_eval do
  
  def photo_browser_button(method, options = {})
    @template.photo_browser_button_tag(@object_name, method, objectify_options(options))
  end
  
end
