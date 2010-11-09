require File.dirname(__FILE__) + '/../test_helper'
class DocumentsControllerTest < ActionController::TestCase
  
  should_have_member_only_actions :create, :index, :new
  should_have_owner_only_actions :edit, :destroy, :update
  
  context "index action" do
    should "render index template" do
      expect_logged_in_member
      get :index
      assert_template 'index'
    end
  end
  
  context "show action" do
    setup do
      @document = Factory.create(:document)
    end
    
    should "redirect to document's file" do
      get :show, :id => @document
      assert_redirected_to @document.url_for_file
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
      expect_logged_in_member
    end
    
    should "render new template when model is invalid" do
      Document.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Document.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to documents_url
    end
  end
  
  context "edit action" do
    setup do
      stub_access
      @document = Factory.create(:document)
    end
    
    should "render edit template" do
      get :edit, :id => @document
      assert_template 'edit'
    end
  end
  
  context "update action" do
    setup do
      stub_access      
      @document = Factory.create(:document)
    end
    
    should "render edit template when model is invalid" do
      Document.any_instance.stubs(:valid?).returns(false)
      put :update, :id => @document
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Document.any_instance.stubs(:valid?).returns(true)
      put :update, :id => @document
      assert_redirected_to documents_url
    end
  end
  
  context "destroy action" do
    setup do
      stub_access
      @document = Factory.create(:document)
    end
    
    should "destroy model and redirect to index action" do
      delete :destroy, :id => @document
      assert_redirected_to documents_url
      assert !Document.exists?(@document.id)
    end
  end
end
