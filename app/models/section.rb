class Section < ActiveRecord::Base

  include TramlinesImages

  VIEW_OPTIONS = [
    ['Normal', 'normal'],
    ['Latest Stories', 'latest_stories'],
    ['First Page', 'first_page']
  ]
  
  default_scope :order => 'weight, created_at'
  
  belongs_to :parent, :class_name => 'Section', :foreign_key => :parent_id
  belongs_to :photo
  has_many :children, :class_name => 'Section', :foreign_key => :parent_id, :dependent => :destroy, :order => 'weight, created_at'
  has_many :pages, :order => 'weight, created_at'
  
  has_permalink

  validates_presence_of :name
  
  named_scope :root, :conditions => {:parent_id => nil}
  
  search_attributes %w{name}, :autocomplete => false

  class << self
    
    def about_us
      Section.find_by_name("About Us")
    end
    
    def news
      Section.find_or_create_by_name("News")
    end
    
  end
  
  def first_page
    pages.first
  end
  
  def get_published_pages
    pages.published
  end
  
  def has_photo?
    !photo.nil?
  end
  
  def last_month_and_year
    month_and_years.first
  end
  
  # Returns an array of month and year number in the form [[month_num, year_num], [month_num, year_num], ...]
  def month_and_years
    sorted_pages = get_published_pages.sort_by {|page| page.publish_on}.reverse
    sorted_pages.map {|page| page.publish_month_and_year}.uniq
  end
  
  def root
    parent ? parent : self
  end
  
  def to_s
    name
  end
  
end
