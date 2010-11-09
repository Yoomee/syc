require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class EnquiriesControllerTest < ActionController::TestCase
  
  should_have_admin_only_actions :destroy, :index, :show

  context "create action" do    
    
    setup do
      stub_access
    end
    
    should "redirect when model is valid" do
      Enquiry.any_instance.stubs(:valid?).returns(true)
      post :create, :enquiry => {:form_name => 'contact'}
      assert_redirected_to root_url
    end
  
    should "render new template when model is invalid" do
      Enquiry.any_instance.stubs(:valid?).returns false
      post :create, :enquiry => {:form_name => 'contact'}
      assert_template 'new'
    end
    
  end

  context "destroy action" do

    setup do
      stub_access
      @enquiry = Factory.create(:enquiry)
    end
    
    should "destroy model and redirect to index action" do
      delete :destroy, :id => @enquiry
      assert_redirected_to enquiries_url
      assert !Enquiry.exists?(@enquiry.id)
    end

  end

  context "index action" do

    setup do
      stub_access
    end

    should "render index template" do
      get :index
      assert_template 'index'
    end

  end
  
  context "new action" do
    
    should "render new template" do
      get :new, :id => 'contact'
      assert_template 'new'
    end
    
  end
  
  context "show action" do

    setup do
      stub_access
      @enquiry = Factory.create(:enquiry)
    end
    
    should "render show template" do
      get :show, :id => @enquiry
      assert_template 'show'
    end

  end
  
end
