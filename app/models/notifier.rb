class Notifier < ActionMailer::Base

  helper :application, :links, :options_panel, :settings, :text

  # NOTE If the following is used (client templates for notifier) the whole directory must be copied to the client directory
  if File.exists? "#{RAILS_ROOT}/client/app/views/notifier"
    Notifier.template_root = "#{RAILS_ROOT}/client/app/views"
  end

  def share_link model_instance, email_details
    recipients email_details[:recipient_email]
    from email_details[:email]
    subject "Thought you might be interested in this #{model_instance.class.name.to_s.downcase}"
    @body['email_details'] = email_details
    @body['model'] = model_instance
  end

end