class DocumentsController < ApplicationController
  
  member_only :create, :index, :new
  owner_only :edit, :destroy, :update

  admin_link 'Documents', :new, 'New document'
  admin_link 'Documents', :index, 'List documents'  

  dont_set_waypoint_for :show

  before_filter :get_document, :only => %w{edit destroy show update}
  
  def index
    @documents = @logged_in_member.is_admin? ? Document.all : @logged_in_member.documents
  end
  
  def show
    redirect_to @document.url_for_file
  end
  
  def new
    @document = Document.new(:member => @logged_in_member)
  end
  
  def create
    @document = Document.new(params[:document])
    if @document.save
      flash[:notice] = "Successfully created document."
      redirect_to documents_url
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @document.update_attributes(params[:document])
      flash[:notice] = "Successfully updated document."
      redirect_to documents_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @document.destroy
    flash[:notice] = "Successfully deleted document."
    redirect_to documents_url
  end
  
  private
  def get_document
    @document = Document.find(params[:id])
  end
  
end
