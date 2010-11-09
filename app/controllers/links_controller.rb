class LinksController < ApplicationController
  
  member_only :create, :new
  owner_only :edit, :destroy, :update

  before_filter :get_member, :only => %w{index}
  
  def index
    @links = @member ? @member.links : Link.all
  end
  
  def show
    @link = Link.find(params[:id])
  end
  
  def new
    @link = Link.new(:member => @logged_in_member)
  end
  
  def create
    @link = Link.new(params[:link])
    if @link.save
      flash[:notice] = "Successfully created link."
      save_site_info
      redirect_to @link
    else
      render :action => 'new'
    end
  end
  
  def edit
    @link = Link.find(params[:id])
  end
  
  def update
    @link = Link.find(params[:id])
    if @link.update_attributes(params[:link])
      flash[:notice] = "Successfully updated link."
      save_site_info
      redirect_to @link
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @link = Link.find(params[:id])
    @link.destroy
    flash[:notice] = "Successfully destroyed link."
    redirect_to links_url
  end
  
  private
  def get_member
    @member = Member.find(params[:member_id]) if params[:member_id]
  end

  def save_site_info
    if @link.url_changed? || @link.url_error?
      LinksWorker.asynch_save_site_info(:link_id => @link.id)
      flash[:notice] << " We are currently retrieving a #{@link.has_image? ? 'new ' : ''}thumbnail for you, which should appear next time you view this page."
    end
  end
  
end
