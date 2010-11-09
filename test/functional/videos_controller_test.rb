require File.dirname(__FILE__) + '/../test_helper'
class VideosControllerTest < ActionController::TestCase

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
      @video = Factory.create(:video)
    end
    
    should "render show template" do
      get :show, :id => @video
      assert_template 'show'
    end
  end
  
  context "new action" do
    should "render new template" do
      stub_access
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do    
    setup do
      stub_access
    end
    should "render new template when model is invalid" do
      Video.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Video.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to video_url(assigns(:video))
    end
  end
  
  context "edit action" do
    setup do
      stub_access
      @video = Factory.create(:video)
    end
    should "render edit template" do
      get :edit, :id => @video
      assert_template 'edit'
    end
  end
  
  context "update action" do
    setup do
      stub_access      
      @video = Factory.create(:video)
    end
    
    should "render edit template when model is invalid" do
      Video.any_instance.stubs(:valid?).returns(false)
      put :update, :id => @video
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Video.any_instance.stubs(:valid?).returns(true)
      put :update, :id => @video
      assert_redirected_to video_url(@video)
    end
  end
  
  context "destroy action" do
    setup do
      stub_access
      @video = Factory.create(:video)
    end
    
    should "destroy model and redirect to index action" do
      delete :destroy, :id => @video
      assert_redirected_to videos_url
      assert !Video.exists?(@video.id)
    end
  end
end
