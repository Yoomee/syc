module LinksHelper

end

ActionView::Helpers::UrlHelper.module_eval do

  unless method_defined?(:link_to_without_prefixing)

    def link_to_function_with_prefixing(name, *args, &block)
      html_options = args.extract_options!.symbolize_keys
      prefix = html_options.delete(:prefix) || ''
      suffix = html_options.delete(:suffix) || ''
      "#{prefix}#{link_to_function_without_prefixing(name, *args << html_options, &block)}#{suffix}"
    end
    alias_method_chain :link_to_function, :prefixing
    
    def link_to_with_prefixing(*args, &block)
      if block_given?
        options = args.first || {}
        html_options = args.second || {}
        prefix = html_options.delete(:prefix) || ''
        suffix = html_options.delete(:suffix) || ''
        "#{prefix}#{link_to_without_prefixing(options, html_options, &block)}#{suffix}"
      else
        name = args.first
        options = args.second || {}
        html_options = args.third || {}
        prefix = html_options.delete(:prefix) || ''
        suffix = html_options.delete(:suffix) || ''        
        "#{prefix}#{link_to_without_prefixing(name, options, html_options)}#{suffix}"
      end
    end
    alias_method_chain :link_to, :prefixing

  end
  
end
