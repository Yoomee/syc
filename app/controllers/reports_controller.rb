class ReportsController < ApplicationController
  
  admin_only :create, :new
  
  before_filter :get_report_class
  
  def create
    @report = @report_class.new params[:report]
    case @report.view
      when 'html'
        render :layout => false
      else
        # Do something different
    end
  end
  
  def new
    @report = @report_class.new(params)
  end
  
  private
  def get_report_class
    @report_class = "#{params.delete(:name).camelize}Report".constantize
  end
  
end