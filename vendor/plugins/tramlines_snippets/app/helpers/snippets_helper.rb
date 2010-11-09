module SnippetsHelper
  
  def snippet(item, name = nil)
    if item.has_snippet?(name)
      content_tag :div, item.snippet_text(name), :class => name
    end
  end
  
end