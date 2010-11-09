class Page < ActiveRecord::Base

  include TramlinesImages

  FORM_TABS = %w{details snippets publishing related_items}
  SUMMARY_LENGTH = 100
  
  belongs_to :photo, :autosave => true
  belongs_to :section

  acts_as_taggable
  has_permalink
  has_related_items
  has_snippets

  validates_presence_of :expires_on, :publish_on, :section, :text, :title

  formatted_time_accessor :publish_on, :expires_on
  
  named_scope :latest, :order => 'publish_on DESC'
  named_scope :published, lambda{{:conditions => ["publish_on <= :now AND expires_on > :now", {:now => Time.zone.now}]}}
  named_scope :weighted, :order => 'weight'
  named_scope :for_month_and_year, lambda{|month, year| {:conditions => ["MONTH(publish_on)=:month AND YEAR(publish_on)=:year", {:month => month, :year => year}]}}
  
  search_attributes %w{title intro text}
  
  # Comparator
  def <=> other_page
    if weight != other_page.weight
      weight <=> other_page.weight
    else
      other_page.publish_on <=> publish_on
    end
  end
  
  def been_published?
    Time.zone.now >= publish_on
  end
  
  def expired?
    Time.zone.now > expires_on
  end
  
  def expires?
    expires_on < Time.local(2035)
  end
  
  def form_tabs
    self.class::FORM_TABS.dup
  end
  
  def has_photo?
    !photo.nil?
  end
  
  def initialize_with_defaults(attrs = {})
    initialize_without_defaults(attrs) do
      self.publish_on = Time.zone.now if publish_on.nil?
    end
  end
  alias_method_chain :initialize, :defaults
  
  # Returns an array of the form [month_number, year_number]
  def publish_month_and_year
    [publish_on.month, publish_on.year]
  end
  
  def published?
    been_published? && !expired?
  end
  
  def root_section
    section.root
  end
  
  def status_string
    now = Time.now
    if publish_on > now
      'This page has not been published yet.'
    elsif expires_on < now
      'This page has now expired.'
    elsif !approved?
      'This page has not been approved.'
    end
  end
  
  def summary(length = SUMMARY_LENGTH)
    summary_string = has_snippet?(:summary) ? snippet_summary : text
    summary_string.truncate_html(length)
  end
  
  def summary_fields
    [:text, :intro]
  end
  
  def to_s
    title
  end
  
  # this is overidden in tramlines_events plugin so that page is described as event if need be
  def type_name
    "page"
  end

end
  
