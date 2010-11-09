class MailNotifier < ActionMailer::Base
  
  def mail(mail)
    from mail.from
    subject mail.subject
    recipients mail.recipient_email
    headers "X-Tramlines-Model" => "Member", "X-Tramlines-Model-Id" => mail.recipient_id
    @html_body, @plain_body = mail.html_body, mail.plain_body
    @mail = mail
  end
  
end