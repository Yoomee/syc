module PermissionsHelper
  
  def allowed_to?(url_item, options = {})
    # Dup options, because we don't want any modifications to be passed to link_to
    options = options.dup
    options.symbolize_keys!
    raise ArgumentError.new("PermissionsHelper#allowed_to? should take a REST helper Proc for its first argument rather than a String, eg. page_proc(page)") if url_item.is_a?(String)
    member = options[:member] || @logged_in_member
    options[:method] ||= :get
    if url_item.is_a?(Hash)
      ActiveSupport::Deprecation.warn("PermissionsHelper#allowed_to? should take a Proc for its first argument rather than a hash, eg. page_proc(page). This will make Tramlines run much faster!!!") unless caller.first =~ /link_if_allowed/
      url_options = url_item.symbolize_keys
      url_options[:action] ||= 'index'
    elsif url_item.is_a?(Proc)
      #url_options = ActionController::Routing::Routes.recognize_path(url, :method => options[:method])
      url_options = url_item.call(:path_hash)
      case options[:method].try(:to_sym)
        when :delete
          url_options[:action] = 'destroy'
        when :post 
          url_options[:action] = 'update' # Shouldn't really be needed
      end
    else
      # If model itself has been passed-in
      return allowed_to?(proc_for(url_item), options)
    end
    url_controller = "#{url_options.delete(:controller).camelcase}Controller".constantize
    url_controller.allowed_to?(url_options, member)
  end
    
  def link_if_allowed(*args, &block)
    if block_given?
      url_proc = args.first
      ActiveSupport::Deprecation.warn("PermissionsHelper#allowed_to? should take a Proc for its first argument rather than a hash, eg. page_proc(page). This will make Tramlines run much faster!!!", caller) if url_proc.is_a?(Hash)
      html_options = args.second || {}
      allowed_to?(url_proc, html_options) ? link_to(resolve_path(url_proc), html_options, &block) : ''
    else
      name = args.first
      url_proc = args.second
      ActiveSupport::Deprecation.warn("PermissionsHelper#allowed_to? should take a Proc for its first argument rather than a hash, eg. page_proc(page). This will make Tramlines run much faster!!!", caller) if url_proc.is_a?(Hash)
      html_options = args.third || {}
      allowed_to?(url_proc, html_options) ? link_to(name, resolve_path(url_proc), html_options) : ''
    end
  end
  alias_method :link_to_if_allowed, :link_if_allowed
  
  def link_to_remote_if_allowed(name, options = {}, html_options = nil)
    url_proc = options.delete(:url)
    ActiveSupport::Deprecation.warn("PermissionsHelper#allowed_to? should take a Proc for its first argument rather than a hash, eg. page_proc(page). This will make Tramlines run much faster!!!", caller) if url_proc.is_a?(Hash)
    allowed_to?(url_proc, options) ? link_to_remote(name, options.merge(:url => resolve_path(url_proc)), html_options) : ''
  end
  
  private
  def proc_for(obj)
    send("#{obj.class.to_s.underscore.gsub(/\//, '_')}_proc", obj)
  end
  
  def resolve_path(url_proc_or_hash, method = nil)
    if url_proc_or_hash.is_a?(Proc)
      url_proc_or_hash.call(:path)
    else
      url_proc_or_hash
    end
  end
  
end
