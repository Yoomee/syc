require File.dirname(__FILE__) + '/../test_helper'
class AdminControllerTest < ActionController::TestCase
  
  should_have_admin_only_action :index
  
  context "index action" do
    
    setup do
      stub_access
    end
    
    context "GET" do
      
      setup do
        get :index
      end
      
      should assign_to(:admin_tabs).with_kind_of(Array)
      should assign_to(:selected_tab).with_kind_of(AdminTab)
      should render_template :index
      
    end
    
  end
  
end
