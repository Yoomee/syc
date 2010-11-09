require File.dirname(__FILE__) + '/../test_helper'
class HomeControllerTest < ActionController::TestCase
  
  should_have_open_action :index
  
  context "all controller/action views on call to *_proc where a parameter is not passed" do
    
    setup do
      get :index
      @prc = members_proc
    end
    
    should "give the same result calling the proc with :path as calling *_path" do
      assert_equal members_path, @prc.call(:path)
    end
    
    should "give the same result calling the proc with :path_hash as calling hash_for_*_path" do
      assert_equal hash_for_members_path, @prc.call(:path_hash)
    end
    
    should "give the same result calling the proc with :url as calling *_url" do
      assert_equal members_url, @prc.call(:url)
    end
    
    should "give the same result calling the proc with :url_hash as calling hash_for_*_url" do
      assert_equal hash_for_members_url, @prc.call(:url_hash)
    end
    
  end
  
  context "all controller/action views on call to *_proc where a parameter is passed" do
    
    setup do
      @member = Factory.create(:member)
      get :index
      @prc = member_proc(@member)
    end
    
    should "give the same result calling the proc with :path as calling *_path" do
      assert_equal member_path(@member), @prc.call(:path)
    end
    
    should "give the same result calling the proc with :path_hash as calling hash_for_*_path" do
      assert_equal hash_for_member_path(:id => @member), @prc.call(:path_hash)
    end
    
    should "give the same result calling the proc with :url as calling *_url" do
      assert_equal member_url(@member), @prc.call(:url)
    end
    
    should "give the same result calling the proc with :url_hash as calling hash_for_*_url" do
      assert_equal hash_for_member_url(:id => @member), @prc.call(:url_hash)
    end
    
  end

  context "on GET to index" do
    
    setup do
      File.stubs(:exists?).returns true
    end
    
    should "render holding view if it exists and member is not logged in" do
      File.expects(:exists?).with("#{RAILS_ROOT}/client/app/views/home/holding.html.erb").returns true
      @controller.stubs(:render).returns true
      @controller.request.expects(:path).returns '/'
      @controller.expects(:render).with(:file => "#{RAILS_ROOT}/client/app/views/home/holding.html.erb", :layout => false).returns true
      get :index
      assert assigns['is_home']
    end

    should "render index if holding view exists and member is logged in" do
      File.expects(:exists?).with("#{RAILS_ROOT}/client/app/views/home/holding.html.erb").returns true
      @controller.expects(:find_logged_in_member).returns Factory.create(:member, :id => 123)
      get :index
      #assert_template :index
      assert assigns['is_home']
    end

    should "render index if holding view exists and request path is /logged-out" do
      File.expects(:exists?).with("#{RAILS_ROOT}/client/app/views/home/holding.html.erb").returns true
      @controller.expects(:find_logged_in_member).returns nil
      @controller.request.expects(:path).returns '/logged-out'
      get :index
      #assert_template :index
      assert assigns['is_home']
    end
      
  end
  
end
