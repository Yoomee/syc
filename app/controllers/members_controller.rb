class MembersController < ApplicationController

  before_filter :get_member, :only => %w{edit update show}
  
  member_only :show
  owner_only :edit, :update
  
  def create
    @member = Member.new(params[:member])
    if @member.save
      flash[:notice] = "Your account has been created. Welcome to #{APP_CONFIG['site_name']}."
      session[:logged_in_member_id] = @member.id
      redirect_to @member
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def index
    @members = Member.all
  end
  
  def new
    @member = Member.new
  end
  
  def show
  end
    
  def update
   if @member.update_attributes(params[:member])
     respond_to do |format|
       format.html do
         flash[:notice] = "Profile updated"
         redirect_to @member
       end
       format.js do
         if wants = params[:wants]
           render(:text => @member.send(params[:wants]))
         else
           render(:text => 'Success')
         end
       end
     end
   else
     render :partial => 'edit'
   end
  end
     
  private
  def get_member
    @member = Member.find params[:id]
  end
  
end