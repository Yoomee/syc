require File.dirname(__FILE__) + '/../test_helper'
class PagesControllerTest < ActionController::TestCase
  
  should_have_admin_only_actions %w{create destroy edit new update}
  should_have_open_actions %w{show}

  context "class on call to allowed_to?" do
  
    should 'return false with show for an expired page if the member is not an admin' do
      page = Factory.create(:expired_page)
      member = Factory.build(:member)
      assert !PagesController.allowed_to?({:action => 'show', :id => page.id}, member)
    end
  
    should 'return false with show for an expired page if there is no logged-in member' do
      page = Factory.create(:expired_page)
      assert !PagesController.allowed_to?({:action => 'show', :id => page.id}, nil)
    end
  
    should 'return false with show for an unpublished page if the member is not an admin' do
      page = Factory.create(:unpublished_page)
      member = Factory.build(:member)
      assert !PagesController.allowed_to?({:action => 'show', :id => page.id}, member)
    end
  
    should 'return false with show for an unpublished page if there is no logged-in member' do
      page = Factory.create(:unpublished_page)
      assert !PagesController.allowed_to?({:action => 'show', :id => page.id}, nil)
    end

    should 'return true with show for an expired page if the member is an admin' do
      page = Factory.create(:expired_page)
      member = Factory.build(:admin_member)
      assert PagesController.allowed_to?({:action => 'show', :id => page.id}, member)
    end
    
    should 'return true with show for an unpublished page if the member is an admin' do
      page = Factory.create(:unpublished_page)
      member = Factory.build(:admin_member)
      assert PagesController.allowed_to?({:action => 'show', :id => page.id}, member)
    end
    
  end

  context "create action with invalid attributes" do

    setup do
      stub_access
      @page = Factory.build(:page)
      Page.stubs(:new).returns @page
      @page.stubs(:save).returns false
    end

    context "POST" do

      setup do
        post :create, :page => {:valid_attributes => false}
      end

      before_should "initialize a page with the attributes" do
        Page.expects(:new).with('valid_attributes' => false).returns @page
      end

      before_should "attempt to save the section" do
        @page.expects(:save).returns false
      end

      should_assign_to(:page) {@page}
      should_render_template :new

    end

  end

  context "create action with valid attributes" do

    setup do
      stub_access
      @page = Factory.build(:page)
      Page.stubs(:new).returns @page
      @page.stubs(:save).returns true
    end

    context "POST" do

      setup do
        post :create, :page => {:valid_attributes => true}
      end

      before_should "initialize a page with the attributes" do
        Page.expects(:new).with('valid_attributes' => true).returns @page
      end

      before_should "save the page" do
        @page.expects(:save).returns true
      end

      should_respond_with(:redirect)

    end

  end

  context "destroy action" do

    setup do
      stub_access
      @page = Factory.build(:page)
      Page.stubs(:find).returns @page
      @page.stubs(:destroy).returns true
    end

    context "DELETE" do

      setup do
        delete :destroy, :id => 123
      end

      before_should "find the page" do
        Page.expects(:find).with('123').returns @page
      end

      before_should "delete the page" do
        @page.expects(:destroy).returns true
      end

      should_redirect_to('the section') {section_path(@page.section)}

    end

  end

  context "edit action" do

    setup do
      stub_access
      @page = Factory.build(:page)
      Page.stubs(:find).returns @page
    end

    context "GET" do

      setup do
        get :edit, :id => 123
      end

      before_should "find the page" do
        Page.expects(:find).with('123').returns @page
      end

      should_assign_to(:page) {@page}
      should_render_template :edit
      
      # should "render the text textarea" do
      #   assert_select "textarea#page_text_editor"
      # end

    end

  end

  context "new action" do

    setup do
      stub_access
      @page = Factory.build(:page)
      Page.stubs(:new).returns @page
    end

    context "GET" do

      setup do
        get :new
      end

      before_should "initialize a page" do
        Page.expects(:new).returns @page
      end

      should_assign_to(:page) {@page}
      should_render_template :new

    end

  end

  context "new action where section id is set" do

    setup do
      Section.stubs(:find).returns Factory.build(:section, :id => 123)
      Section.stubs(:find).with {|*args| args.first == :all}.returns [Factory.build(:section)]
      stub_access
    end

    context "GET" do

      setup do
        get :new, :section_id => 123
      end

      should_assign_to :page, :class => Page
      should_render_template :new

      should "set the section id for the page" do
        assert_equal 123, assigns['page'].section_id
      end

    end

  end

  context "show action" do

    setup do
      @page = Factory.build(:page, :id => 123)
      Page.stubs(:find).returns @page
      Page.stubs(:find).with {|*args| args.first == :all}.returns [@page]
    end

    context 'GET' do

      setup do
        get :show, :id => 123
      end

      before_should "find the page" do
        Page.expects(:find).with('123').returns @page
      end

      should_assign_to(:page) {@page}
      should_render_template :show

    end

  end

  context "show action for page with photo" do

    setup do
      @page = Factory.build(:page_with_photo, :id => 123)
      Page.stubs(:find).returns @page
      Page.stubs(:find).with {|*args| args.first == :all}.returns [@page]
    end

    context 'GET' do

      setup do
        get :show, :id => 123
      end

      before_should "find the page" do
        Page.expects(:find).with('123').returns @page
      end

      should_render_template :show
      should_assign_to(:page) {@page}

    end

  end

  context "update action with invalid attributes" do

    setup do
      stub_access
      @page = Factory.build(:page, :id => 123)
      Page.stubs(:find).returns @page
      @page.stubs(:update_attributes).returns false
    end

    context 'PUT' do

      setup do
        put :update, :id => 123, :page => {:valid_attributes => false}
      end

      before_should "find the page" do
        Page.expects(:find).with('123').returns @page
      end

      before_should "attempt to save the page" do
        @page.expects(:update_attributes).with('valid_attributes' => false).returns false
      end

      should_assign_to(:page) {@page}
      should_render_template :edit

    end

  end

  context "update action with valid attributes" do

    setup do
      stub_access
      Section.stubs(:find).with(:all).returns [Factory.build(:section)]
      @page = Factory.build(:page)
      Page.stubs(:find).returns @page
      @page.stubs(:update_attributes).returns true
    end

    context 'PUT' do

      setup do
        put :update, :id => 123, :page => {:valid_attributes => true}
      end

      before_should "find the page" do
        Page.expects(:find).with('123').returns @page
      end

      before_should "save the page" do
        @page.expects(:update_attributes).with('valid_attributes' => true).returns true
      end

      should_respond_with(:redirect)

    end

  end

end
