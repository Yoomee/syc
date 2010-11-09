module OptionsPanelHelper
  
  def self.included(klass)
    klass.send(:attr_accessor, :separating_links, :prefixing_separated_links)
  end
  
  def back_link
    link_to_waypoint 'Back'
  end
  
  def options_panel(&block)
    out = content_tag(:br, '', :class => 'clear')
    out << content_tag(:div, :class => 'options_panel') {separate_links(&block)}
    concat(out)
  end
  
  def separate_links(&block)
    self.separating_links = true
    self.prefixing_separated_links = false
    out = capture(&block).strip
    self.prefixing_separated_links = false
    self.separating_links = false
    concat(out)
  end
  
end

module ActionView::Helpers::UrlHelper
  
  unless method_defined?(:link_to_without_link_separation)

    def link_to_function_with_link_separation(name, *args, &block)
      if separating_links
        if prefixing_separated_links
          html_options = args.extract_options!.symbolize_keys
          html_options[:prefix] ||= ' | '
          link_to_function_without_link_separation(name, *args << html_options, &block)
        else
          self.prefixing_separated_links = true
          link_to_function_without_link_separation(name, *args, &block)
        end
      else
        link_to_function_without_link_separation(name, *args, &block)
      end
    end
    alias_method_chain :link_to_function, :link_separation

    def link_to_with_link_separation(*args, &block)
      if separating_links
        if prefixing_separated_links
          if block_given?
            options = args.first || {}
            html_options = args.second || {}
            html_options[:prefix] ||= ' | '
            link_to_without_link_separation(options, html_options, &block)
          else
            name = args.first
            options = args.second || {}
            html_options = args.third || {}
            html_options[:prefix] ||= ' | '
            link_to_without_link_separation(name, options, html_options)
          end
        else
          self.prefixing_separated_links = true
          link_to_without_link_separation(*args, &block)
        end
      else
        link_to_without_link_separation(*args, &block)
      end
    end
    alias_method_chain :link_to, :link_separation
    
  end

end
