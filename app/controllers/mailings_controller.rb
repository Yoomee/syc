class MailingsController < ApplicationController

  admin_only :create, :destroy, :edit, :index, :new, :send_emails, :show, :update

  def create
    @mailing = Mailing.new(params[:mailing])
    if @mailing.save
      flash[:notice] = "Successfully created mailing."
      redirect_to @mailing
    else
      render :action => 'new'
    end
  end

  def destroy
    @mailing = Mailing.find(params[:id])
    @mailing.destroy
    flash[:notice] = "Successfully destroyed mailing."
    redirect_to mailings_url
  end
  
  def edit
    @mailing = Mailing.find(params[:id])
  end
  
  def index
    @mailings = Mailing.all
  end
  
  def new
    @mailing = Mailing.new
  end

  def send_emails
    @mailing = Mailing.find(params[:id])
    if @mailing.send_emails!
      flash[:notice] = "Emails have been sent"
    else
      flash[:error] = "There was a problem sending the emails"
    end
    redirect_to :action => 'index'
  end
  
  def show
    @mailing = Mailing.find(params[:id])
  end
  
  def update
    @mailing = Mailing.find(params[:id])
    if @mailing.update_attributes(params[:mailing])
      flash[:notice] = "Successfully updated mailing."
      redirect_to @mailing
    else
      render :action => 'edit'
    end
  end

end
