require File.dirname(__FILE__) + '/../test_helper'
class LinksControllerTest < ActionController::TestCase

  should_have_member_only_actions :create, :new
  should_have_owner_only_actions :edit, :destroy, :update
  
  context "index action" do 
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end
  
  context "show action" do
    setup do
      @link = Factory.create(:link)
    end
    
    should "render show template" do
      get :show, :id => @link
      assert_template 'show'
    end
  end
  
  context "new action" do
    should "render new template" do
      expect_logged_in_member
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do    
    setup do
      stub_access
    end
    should "render new template when model is invalid" do
      Link.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Link.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to link_url(assigns(:link))
    end
  end
  
  context "edit action" do
    setup do
      stub_access
      @link = Factory.create(:link)
    end
    should "render edit template" do
      get :edit, :id => @link
      assert_template 'edit'
    end
  end
  
  context "update action" do
    setup do
      stub_access      
      @link = Factory.create(:link)
    end
    
    should "render edit template when model is invalid" do
      Link.any_instance.stubs(:valid?).returns(false)
      put :update, :id => @link
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Link.any_instance.stubs(:valid?).returns(true)
      put :update, :id => @link
      assert_redirected_to link_url(@link)
    end
  end
  
  context "destroy action" do
    setup do
      stub_access
      @link = Factory.create(:link)
    end
    
    should "destroy model and redirect to index action" do
      delete :destroy, :id => @link
      assert_redirected_to links_url
      assert !Link.exists?(@link.id)
    end
  end
end
