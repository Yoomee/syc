class DocumentFoldersController < ApplicationController
  
  owner_only :edit, :update, :destroy
  member_only :new, :create, :show, :index

  admin_link 'Documents', :new, 'New document folder'
  admin_link 'Documents', :index, 'List documents'
  
  def index
    case
    when @logged_in_member.is_admin?
      @document_tabs = Document::CONTEXTS
      @selected_tab = params[:tab_name] || 'page'
      @document_folders = DocumentFolder.send("for_#{@selected_tab}")
      @documents_without_folder = Document.send("for_#{@selected_tab}").without_folder
    when @logged_in_member.is_primary?
      @document_folders = DocumentFolder.for_primary
      @documents_without_folder = Document.for_primary.without_folder
    when @logged_in_member.is_secondary?
      @document_folders = DocumentFolder.for_secondary
      @documents_without_folder = Document.for_secondary.without_folder
    else
      @document_folders = DocumentFolder.all
      @documents_without_folder = @logged_in_member.documents.without_folder
    end
  end
  
  def new
    @document_folder = DocumentFolder.new(:context => params[:context])
  end
  
  def create
    @document_folder = DocumentFolder.new(params[:document_folder])
    if @document_folder.save
      flash[:notice] = "Successfully created folder."
      redirect_to "/documents?tab_name=#{@document_folder.context}"
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @document_folder = DocumentFolder.find(params[:id])
    @document_folder.destroy
    flash[:notice] = "Successfully deleted folder."
    redirect_to "/documents?tab_name=#{@document_folder.context}"
  end
  
  def edit
    @document_folder = DocumentFolder.find(params[:id])
  end
  
  def update
    @document_folder = DocumentFolder.find(params[:id])
    if @document_folder.update_attributes(params[:document_folder])
      flash[:notice] = "Successfully updated folder."
      redirect_to "/documents?tab_name=#{@document_folder.context}"
    else
      render :action => 'edit'
    end
  end
  
  def show
    @document_folder = DocumentFolder.find(params[:id])
  end
  
  protected
  def begin_of_association_chain
   admin_logged_in? ? nil : @logged_in_member
  end
  
end
