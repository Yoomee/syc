# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  ExceptionNotifier.exception_recipients = %w{si@yoomee.com rob@yoomee.com ian@yoomee.com}
  ExceptionNotifier.sender_address = "exception.notifier@default.com"

  extend ActiveSupport::Memoizable

  include ApplicationControllerConcerns::Permissions
  include ApplicationControllerConcerns::Tabs
  include ApplicationControllerConcerns::Twitter  
  include ApplicationControllerConcerns::Waypoints
  include ApplicationControllerConcerns::Preprocess 
  
  include ExceptionNotifiable

  include ProvidesAdminItems
  
  # Initialize permissions data for controller
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  helper :all # include all helpers, all the time

  # prepend_view_path "#{RAILS_ROOT}/client/app/views"
  arrange_view_paths

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

end