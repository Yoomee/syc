class SectionsController < ApplicationController

  admin_only :create, :destroy, :edit, :new, :update

  admin_link 'Content', :new, 'New section'
  admin_link 'Content', :index, 'List sections'

  before_filter :get_section, :only => %w{archive destroy edit show update}

  def archive
    begin
      @section = Section.find params[:id]
      @month = params[:month].to_i
      @year = params[:year].to_i
      if @month.zero? || @year.zero?
        month_and_year = @section.last_month_and_year
        @month = month_and_year[0]
        @year = month_and_year[1]
      end
      @page_title = "#{@section.name}: #{Date::MONTHNAMES[@month]} #{@year}"
      @pages = @section.pages.published.for_month_and_year(@month, @year)
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end

  def create
    @section = Section.new(params[:section])
    if @section.save
      flash[:notice] = 'Your section has been created'
      redirect_to_waypoint
    else
      render :action => 'new'
    end
  end
  
  def destroy
    flash[:notice] = 'Section deleted' if @section.destroy
    redirect_to sections_path
  end
  
  def edit
  end
  
  def index
    @sections = Section.root
  end
  
  def new
    @section = Section.new(:parent_id => params[:section_id])
  end
  
  def rss
    begin
      @section = Section.find params[:id]
      @description = APP_CONFIG[:site_slogan] || ""
      @language = "EN"
      @link = APP_CONFIG[:site_url]
      @title = "#{APP_CONFIG[:site_name]} - #{@section.name}"
      render :layout => false
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
  
  def show
    case @section.view
      when 'latest_stories'
        @pages_sections = @section.pages.published.latest + @section.children
        @pages_sections.extend(SortByWeightAndLatest)
        @pages_sections = @pages_sections.sort_by_weight_and_latest.paginate(:page => params[:page], :per_page => (APP_CONFIG[:latest_stories_items_per_page] || 3))
        render :action => 'latest_stories'
      when 'first_page'
        redirect_to page_path(@section.first_page) unless @section.pages.empty?
    end
    # Otherwise use show view
    @pages = @section.pages.published.weighted.paginate(:page => params[:page], :per_page => (APP_CONFIG[:section_pages_items_per_page] || 10))
  end
  
  def update
    if @section.update_attributes(params[:section])
      flash[:notice] = 'Section updated successfully'
      redirect_to_waypoint
    else
      render :action => 'edit'
    end
  end
  
  private
  def get_section
    @section = Section.find params[:id]
  end

  module SortByWeightAndLatest

    def sort_by_weight_and_latest
      sort do |item_a, item_b|
        compare_weight_and_latest(item_a, item_b)
      end
    end

    def compare_weight_and_latest(item_a, item_b)
      weight_comp = (item_a.weight || 0) <=> (item_b.weight || 0)
      return weight_comp unless weight_comp.zero?
      item_b.created_at <=> item_a.created_at
    end

  end  
end

