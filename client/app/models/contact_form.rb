module ContactForm

  include EnquiryForm
  
  title "Contact Us"
  fields :name, :email_address, :address, :i_am_a, :message, :telephone_number, :mobile_number
  
  email_to "information@sheffieldyoungcarers.org.uk"
  email_from "website@sheffieldyoungcarers.org.uk"
  email_subject "New contact form enquiry"
  
  response_message "Thank you for your enquiry. We will be in touch shortly."
  
  validates_presence_of :name, :email_address, :address, :i_am_a, :message, :telephone_number
  
end