class SessionsController < ApplicationController
  
  member_only :destroy

  skip_before_filter :clear_login_redirect, :clear_login_redirect_message, :only => %w{create new}
  
  def create
    @logged_in_member = Member.authenticate(params[:login_email_or_username], params[:login_password])
    if @logged_in_member
      session[:logged_in_member_id] = @logged_in_member.id
      flash[:notice] = "Welcome back #{@logged_in_member.forename}! Thanks for logging in again."
      redirect_to_waypoint
    else
      flash[:error] = "Login details not found. Please try again."
      render :action => 'new'
    end
  end
  
  def destroy
    session[:logged_in_member_id] = nil
    redirect_to root_url
  end
  
  def new
  end
  
end