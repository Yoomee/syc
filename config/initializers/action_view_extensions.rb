ActionView::Template.class_eval do

  #TODO: check efficiency of this method
  def fbml_view_exists?
    ApplicationController.view_paths.each do |view_path|
      return true if File.exists?("#{RAILS_ROOT}/#{view_path}/#{path_without_fbml_check}")
    end
    false
  end
  
  def path_with_fbml_check
    if format == "fbml" && !fbml_view_exists?
      format = "html"
      path_without_fbml_check
    else
      path_without_fbml_check
    end
  end
  alias_method_chain :path, :fbml_check
  
end

ENV['RAILS_ASSET_ID'] = '' if RAILS_ENV == 'development'