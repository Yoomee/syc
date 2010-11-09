require File.dirname(__FILE__) + '/../test_helper'
class PhotoAlbumsControllerTest < ActionController::TestCase
  
  should_have_member_only_actions :create, :new
  should_have_owner_only_actions :edit, :destroy, :update
  
  context "index action" do
    should "render index template" do
      expect_logged_in_member
      get :index
      assert_template 'index'
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
      PhotoAlbum.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      PhotoAlbum.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to photo_album_photos_url(assigns(:photo_album))
    end
  end
  
  context "edit action" do
    setup do
      stub_access
      @photo_album = Factory.create(:photo_album)
    end
    
    should "render edit template" do
      get :edit, :id => @photo_album
      assert_template 'edit'
    end
  end
  
  context "update action when attributes are invalid" do
    
    setup do
      stub_access
      @photo_album = Factory.build(:photo_album, :id => 456)
      PhotoAlbum.stubs(:find).returns @photo_album
      @photo_album.stubs(:update_attributes).returns false
    end
    
    context 'POST' do
      
      setup do
        post :update, :id => 123, :photo_album => {:valid_attributes => false}
      end
      
      before_should "find the photo album" do
        PhotoAlbum.expects(:find).with('123').returns @photo_album
      end
      
      before_should "attempt to save the photo album" do
        @photo_album.expects(:update_attributes).with('valid_attributes' => false).returns false
      end
      
      should_render_template :edit
      
    end
    
  end
  
  context "update action when attributes are valid" do
    
    setup do
      stub_access
      @photo_album = Factory.build(:photo_album, :id => 456)
      PhotoAlbum.stubs(:find).returns @photo_album
      @photo_album.stubs(:update_attributes).returns true
    end
    
    context 'POST' do
      
      setup do
        post :update, :id => 123, :photo_album => {:valid_attributes => true}
      end
  
      before_should "find the photo album" do
        PhotoAlbum.expects(:find).with('123').returns @photo_album
      end
      
      before_should "save the photo album" do
        @photo_album.expects(:update_attributes).with('valid_attributes' => true).returns true
      end
      
      should_redirect_to("the photo album") {photo_album_photos_path(@photo_album)}
      
    end
  end
  
  context "destroy action" do
    setup do
      stub_access
      @photo_album = Factory.create(:photo_album)
    end
    
    should "destroy model and redirect to index action" do
      delete :destroy, :id => @photo_album
      assert_redirected_to photo_albums_url
      assert !PhotoAlbum.exists?(@photo_album.id)
    end
  end
end
