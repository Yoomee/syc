require File.dirname(__FILE__) + '/../test_helper'
class ReportControllerTest < ActionController::TestCase
  
  should_have_admin_only_actions :create, :new
  
  context "new action" do
    
  end
  
end