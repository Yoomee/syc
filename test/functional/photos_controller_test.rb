require File.dirname(__FILE__) + '/../test_helper'
class PhotosControllerTest < ActionController::TestCase

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
      @photo = Factory.create(:photo)
    end
    
    should "render show template" do
      get :show, :id => @photo
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
      expect_logged_in_member
    end
    should "render new template when model is invalid" do
      Photo.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Photo.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to photo_url(assigns(:photo))
    end
  end
  
  context "edit action" do
    setup do
      stub_access
      @photo = Factory.create(:photo)
    end
    should "render edit template" do
      get :edit, :id => @photo
      assert_template 'edit'
    end
  end
  
  context "update action" do
    setup do
      stub_access      
      @photo = Factory.create(:photo)
    end
    
    should "render edit template when model is invalid" do
      Photo.any_instance.stubs(:valid?).returns(false)
      put :update, :id => @photo
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Photo.any_instance.stubs(:valid?).returns(true)
      put :update, :id => @photo
      assert_redirected_to photo_url(@photo)
    end
  end
  
  context "destroy action" do
    setup do
      stub_access
      @photo = Factory.create(:photo)
    end
    
    should "destroy model and redirect to index action" do
      delete :destroy, :id => @photo
      assert_redirected_to photos_url
      assert !Photo.exists?(@photo.id)
    end
  end
end
