module MailHelper
  
  def reply_above_text(text = "")
    MailHandler::ABOVE_THIS_LINE_TEXT << text
  end
  
end