class Mail < ActiveRecord::Base

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
  
  belongs_to :mailing
  belongs_to :recipient, :class_name => 'Member'
  
  delegate :full_name, :to => :recipient, :prefix => true
  
  named_scope :most_recent, :order => "created_at DESC"
  
  validates_presence_of :subject, :recipient, :html_or_plain_body, :from
  
  include AASM
  aasm_column :status
  aasm_initial_state :not_sent
  
  aasm_state :not_sent
  aasm_state :sent
  aasm_state :read
  
  # Events - these do the work!
  
  aasm_event :send_email do
    transitions :from => [:not_sent], :to => :sent, :guard => :deliver!
  end
  
  aasm_event :read do
    transitions :from => [:read, :sent], :to => :read
  end
  
  def from
    return read_attribute(:from) unless read_attribute(:from).blank?
    mailing ? mailing.from : nil
  end
  
  def html_or_plain_body
    html_body.blank? ? plain_body : html_body
  end
  
  def initialize(attributes = {})
    attributes[:from] ||= APP_CONFIG['site_email']
    super
  end
  
  def html_body
    body = read_attribute(:html_body)
    return body unless body.blank?
    return mailing.html_body if mailing && !mailing.html_body.blank?
    read_attribute(:plain_body).blank? ? '' : simple_format(plain_body)
  end
  
  def plain_body
    body = read_attribute(:plain_body)
    return body unless body.blank?
    return mailing.plain_body if mailing && !mailing.plain_body.blank?
    read_attribute(:html_body).blank? ? '' : simple_unformat(html_body)
  end
  
  def recipient_email
    "#{recipient} <#{recipient.email}>"
  end
  
  def multipart?
    has_html_body? && has_plain_body?
  end
  
  def has_html_body?
    !html_body.blank?
  end
  
  def has_plain_body?
    !plain_body.blank?
  end
  
  def subject
    return read_attribute(:subject) unless read_attribute(:subject).blank?
    mailing ? mailing.subject : nil
  end
  
  private
  def deliver!
    MailWorker.async_deliver_mail(:mail_id => self.id)
    # Notifier.deliver_mail(self)
  end
    
end