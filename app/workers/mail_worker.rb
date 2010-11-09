class MailWorker < Workling::Base

  def deliver_mail(options)
    mail = Mail.find(options[:mail_id])
    MailNotifier.deliver_mail(mail)
  end
  
end