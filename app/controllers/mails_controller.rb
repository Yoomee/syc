class MailsController < ApplicationController
  
  admin_only :index

  def create
    @mail = Mail.new(params[:mail])
    if @mail.save
      flash[:notice] = "Successfully created mail."
      redirect_to @mail
    else
      render :action => 'new'
    end
  end

  def destroy
    @mail = Mail.find(params[:id])
    @mail.destroy
    flash[:notice] = "Successfully destroyed mail."
    redirect_to mails_url
  end
  
  def edit
    @mail = Mail.find(params[:id])
  end

  def index
    if params[:mail_id]
      @mailing = Mailing.find(params[:mailing_id])
      @mails = @mail.mails
    else
      @mails = Mail.most_recent
    end
  end
  
  def new
    @member = Member.find(params[:member_id])
    @mail = Mail.new(:recipient => @member)
  end
  
  def read
    @mail = Mail.find params[:id]
    @mail.read!
    send_file "#{RAILS_ROOT}/app/views/mails/read_image.gif"
  end
  
  def send_email
    @mail = Mail.find(params[:id])
    if @mail.send_email!
      flash[:notice] = "Email has been sent"
    else
      flash[:error] = "There was a problem sending the email"
    end
    redirect_to :action => 'index'
  end
  
  def show
    @mail = Mail.find(params[:id])
  end
  
  def update
    @mail = Mail.find(params[:id])
    if @mail.update_attributes(params[:mail])
      flash[:notice] = "Successfully updated mail."
      redirect_to @mail
    else
      render :action => 'edit'
    end
  end
  
end