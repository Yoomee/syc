module LayoutHelper
  
  def body_tag(options = {}, &block)
    options[:id] ||= id_for_body_tag
    body_class = "#{classes_for_body_tag_string} #{options[:class]}".strip
    options[:class] = body_class unless body_class.blank?
    concat content_tag(:body, capture(&block), options)
  end

  def classes_for_body_tag_string
    classes_for_body_tag.join(' ')
  end
  
  def content_tag_with_active(*args, &block)
    options = args.extract_options!.symbolize_keys
    options ||= {}
    options[:class] = (options[:class].blank? ? "active" : options[:class] + " active") if args.second
    if block_given?
      content_tag(args.first, options, &block)
    else
      content_tag(args.first, args.third, options)
    end
  end
  
  def li_with_active(*args, &block)
    content_tag_with_active(:li, *args, &block)
  end
  
  private
  def classes_for_body_tag
    returning classes = [] do
      classes << case
        when @section && @section.id
          "section_#{@section.id} section_#{@section.name}"
        when @page && @page.is_a?(Page)          
          "page_#{@page.id} section_#{@page.section_id}"
      end
      classes << "controller_#{controller_name}"
      classes << "action_#{action_name}"
    end
  end
  
  def id_for_body_tag
    is_home? ? 'home' : 'inside'
  end

end