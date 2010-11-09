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
      
      should_assign_to :admin_tabs, :class => Array
      should_assign_to :selected_tab, :class => AdminTab
      should_render_template :index
      
    end
    
  end
  
end
