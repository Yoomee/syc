module SessionsHelper
  
  def logged_in?
    !@logged_in_member.nil?
  end
  
  def render_login_redirect_message
    content_tag(:div, session[:login_redirect_message], :id => 'login_redirect_message') if session[:login_redirect_message]
  end
  
end