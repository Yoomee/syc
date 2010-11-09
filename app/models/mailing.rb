class Mailing < ActiveRecord::Base
  
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ::TextHelper
  
  class << self
    
    # Needed by TextHelper
    def full_sanitizer
      @full_sanitizer ||= HTML::FullSanitizer.new
    end
    
  end
  
  has_many :mails, :autosave => true
  has_many :unsent_mails, :class_name => 'Mail', :conditions => {:status => 'not_sent'}
  
  validates_presence_of :subject, :html_or_plain_body, :from
  
  def html_or_plain_body
    html_body.blank? ? plain_body : html_body
  end
  
  def html_body
    body = read_attribute(:html_body)
    return body unless body.blank?
    read_attribute(:plain_body).blank? ? '' : simple_format(plain_body)
  end
  
  def initialize(attributes = {})
    attributes[:from] ||= APP_CONFIG['site_email']
    super
  end
  
  def plain_body
    body = read_attribute(:plain_body)
    return body unless body.blank?
    read_attribute(:html_body).blank? ? '' : simple_unformat(html_body)
  end
  
  def not_sent?
    status == 'not_sent'
  end
  
  def send_emails!
    if save!
      create_mails
      unsent_mails.each(&:send_email!)
    end
  end
  
  def status
    mails.empty? ? 'not_sent' : 'sent'
  end
  
  private
  def create_mails
    Member.all.each do |member|
      mails.create(:recipient => member, :status => 'not_sent') unless mails.exists?(:recipient_id => member.id)
    end
  end
  
end