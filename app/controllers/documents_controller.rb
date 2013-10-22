class DocumentsController < ApplicationController
  
  admin_only :create, :new
  member_only :index
  owner_only :edit, :destroy, :update

  admin_link 'Documents', :new, 'New document'
  admin_link 'Documents', :index, 'List documents'  

  dont_set_waypoint_for :show

  before_filter :get_document, :only => %w{edit destroy show update}
  
  def index
    case
    when @logged_in_member.is_admin?
      @document_tabs = Document::CONTEXTS
      @selected_tab = params[:tab_name] || 'pages'
      @documents = Document.send("for_#{@selected_tab}")
    when @logged_in_member.is_primary?
      @documents = Document.for_primary
    when @logged_in_member.is_secondary?
      @documents = Document.for_secondary
    else
      @logged_in_member.documents
    end
  end
  
  def show
    redirect_to @document.url_for_file
  end
  
  def new
    @document = Document.new(:member => @logged_in_member, :context => params[:context])
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
