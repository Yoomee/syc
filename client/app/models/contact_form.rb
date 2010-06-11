module ContactForm

  include EnquiryForm
  
  title "Contact Us"
  fields :name, :email_address, :address, :i_am_a, :message
  
  email_to "si@yoomee.com"
  email_from "website@sheffieldyoungcarers.org.uk"
  email_subject "New contact form enquiry"
  
  validates_presence_of :name, :email_address, :address, :i_am_a, :message
  
end