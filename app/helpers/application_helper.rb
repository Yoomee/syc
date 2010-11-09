# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def render_breadcrumb(breadcrumb, separator = '&nbsp;&gt;&nbsp;')
    # The breadcrumb could be rendered twice, so we should avoid modifying it
    breadcrumb_arr = (breadcrumb || []).dup
    breadcrumb_arr.unshift ["Home",  {:controller => 'home', :action => 'welcome'} ]
    breadcrumb_string = breadcrumb_arr.map do |item|
      if item.size == 2
        if item[1].is_a? Hash
          if !item[1][:action]
            item[1][:action] = 'index'
          end
          link_to item[0], item[1]
        else
          link_to item[0], item[1]
        end
      else
        item[0]
      end
    end
    breadcrumb_string.join separator
  end
  
  def view_exists?(view_name)
    ApplicationController.view_paths.any? do |path|
      File.exists?("#{path}/#{view_name}.html.haml")
    end
  end
  
end
