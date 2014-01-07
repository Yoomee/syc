class DocumentsController < ApplicationController
  
  admin_only :create, :new
  owner_only :edit, :destroy, :update

  admin_link 'Documents', :new, 'New document'

  dont_set_waypoint_for :show

  before_filter :get_document_folder, :only => :new
  before_filter :get_document, :only => %w{edit destroy show update}
  
  def show
    redirect_to @document.url_for_file
  end
  
  def new
    @document = Document.new(:member => @logged_in_member, :folder => @document_folder, :context => @document_folder.try(:context) || params[:context])
  end
  
  def create
    @document = Document.new(params[:document])
    if @document.save
      flash[:notice] = "Successfully created document."
      redirect_to "/documents?tab_name=#{@document.context}"
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @document.update_attributes(params[:document])
      flash[:notice] = "Successfully updated document."
      redirect_to "/documents?tab_name=#{@document.context}"
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @document.destroy
    flash[:notice] = "Successfully deleted document."
    redirect_to "/documents?tab_name=#{@document.context}"
  end
  
  private
  def get_document_folder
    return true if params[:document_folder_id].blank?
    @document_folder = DocumentFolder.find(params[:document_folder_id])
  end

  def get_document
    @document = Document.find(params[:id])
  end
  
end
