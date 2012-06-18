class StaffMembersController < ApplicationController

  before_filter :get_staff_member, :only => %w{edit destroy update}
  
  admin_only :edit, :update, :create, :new, :index, :destroy
  
  def create
    @staff_member = StaffMember.new(params[:staff_member])
    if @staff_member.save
      flash[:notice] = "Staff member created."
      redirect_to staff_members_path
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @staff_member.destroy
    redirect_to staff_members_path
  end
  
  def edit
  end
  
  def new
    position = (StaffMember.find(:all, :order => 'position').last.try(:position) || 0) + 1
    @staff_member = StaffMember.new(:position => position)
  end
  
  def show
  end
  
  def index
    @staff_members = StaffMember.all
  end
    
  def update
    if @staff_member.update_attributes(params[:staff_member])
      flash[:notice] = "Staff member updated"
      redirect_to staff_members_path
    else
      render :partial => 'edit'
    end
  end
     
  private
  def get_staff_member
    @staff_member = StaffMember.find params[:id]
  end
  
end
