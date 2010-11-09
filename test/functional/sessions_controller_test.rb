require File.dirname(__FILE__) + '/../test_helper'
class SessionsControllerTest < ActionController::TestCase

  should_have_open_actions :create, :new
  should_have_member_only_actions :destroy
  
  context "on DELETE to destroy" do
    
    setup do
      session[:logged_in_member_id] = 123
      @controller.expects(:find_logged_in_member).returns Factory.build(:member)
      @controller.stubs(:gate_keep).returns true
      delete :destroy
    end
    
    should_redirect_to('the homepage') {root_url}
    
    should "delete the member from the session" do
      assert_nil session[:logged_in_member_id]
    end
    
  end
  
  context "on GET to new" do
    
    setup do
      @controller.stubs(:gate_keep).returns true
      get :new
    end
    
    should_render_template :new
    
  end
  
  context "on POST to create when the details are invalid" do
    
    setup do
      @controller.stubs(:gate_keep).returns true
      Member.expects(:authenticate).with('test@test.com', 'pa55w0rd').returns nil
      post :create, :login_email_or_username => 'test@test.com', :login_password => 'pa55w0rd'
    end
    
    should_render_template :new
    
  end

  context "on POST to create when the details are valid" do
    
    setup do
      @controller.stubs(:gate_keep).returns true
      @member = Factory.build(:member, :id => 123)
      Member.expects(:authenticate).with('test@test.com', 'pa55w0rd').returns @member
      post :create, :login_email_or_username => 'test@test.com', :login_password => 'pa55w0rd'
    end
    
    should_redirect_to('the homepage') {root_url}

    should "assign the member id to the session" do
      assert_equal 123, session[:logged_in_member_id]
    end
    
  end

end
