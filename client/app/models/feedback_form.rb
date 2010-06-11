module FeedbackForm
  
  include EnquiryForm
  
  title "Site Feedback"
  
  fields :name, :email_address, :message
  
  email_to "si@yoomee.com"
  email_from "website@sheffieldyoungcarers.org.uk"
  email_subject "New Site Feedback submission"
  
  response_message "Thank you for your feedback. We will take it on board, and if appropriate be in touch shortly."
    
  validates_presence_of :name, :email_address, :message
  
end