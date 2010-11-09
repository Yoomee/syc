module ApplicationControllerConcerns::Preprocess
  
  def self.included(klass)
    # Prevent XSS - taken from http://rorramblings.blogspot.com/2008/07/combating-xss.html
    # These files are in lib and vendor
    klass.send(:include, HtmlFilterHelper)

    # Standard before_filters
    klass.before_filter :sanitize_params, :get_logged_in_member, :clear_login_redirect_message, :gate_keep    
  end
  
  def clear_login_redirect_message
    set_login_redirect_message('')
  end
  
  def get_logged_in_member
    @logged_in_member = find_logged_in_member
    # For convenience
    @m = @logged_in_member
  end  
  
  def set_login_redirect_message(message)
    session[:login_redirect_message] = message
  end
  
  # Check that the user has permission to carry out the requested action.
  def gate_keep
    options = params.merge({:controller => self.controller_path, :action => action_name})
    if !respond_to?(action_name)
      @page = "#{self.controller_path}/#{action_name}"
      @page_title = 'Whoops!'
      render_404
    elsif !allowed_to?(options, @logged_in_member)
      @logged_in_member ? render_not_allowed_message : redirect_to_login
    end
  end
  
  def render_404
    render :template => 'application/404', :status => 404
  end

  def find_logged_in_member
    Member.find(session[:logged_in_member_id]) if session[:logged_in_member_id]
  end
  
  def redirect_to_login options = {}
    set_login_redirect_message(APP_CONFIG['insufficient_permission_message'] || '')
    set_waypoint
    return redirect_to(new_session_url)
  end
  
  def render_not_allowed_message
    report_error "You are not allowed to view this page. If you believe this is wrong please contact us <a href='mailto:#{APP_CONFIG[:site_email]}'>here</a>."
  end
    
  # Report a given error message
  def report_error(message)
    @message = message
    @page_title = 'Error'
    return render(:text => @message, :layout => true)
  end

end