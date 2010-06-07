ApplicationController.class_eval do
  
  ExceptionNotifier.email_prefix = 'SYC: '
  
end