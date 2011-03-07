require File.dirname(__FILE__) + '/../test_helper'
class SearchControllerTest < ActionController::TestCase

  should route(:get, "/search/jquery_autocomplete.json").to({:controller => 'search', :action => 'jquery_autocomplete', :format => 'json'})
  
  context "create action" do
    
    setup do
      @search = Search.new(:term => 'Test')
      Search.stubs(:new).returns @search
      @search.stubs(:results).returns [Factory.build(:page)]
    end
    
    context "POST" do
      
      setup do
        post :create, :search => {:term => 'Test'}
      end
      
      before_should "build the search model" do
        Search.expects(:new).with({'term' => 'Test'}, :match_mode => nil, :autocomplete => nil).returns @search
      end
      
      should assign_to(:search).with {@search}
      
      should render_template :create
      
    end
       
  end
  
  context "jquery_autocomplete action" do
    
    setup do
      @search = Search.new(:term => 'Test')
      Search.stubs(:new).returns @search
      @search.stubs(:results).returns [Factory.build(:page)]
    end
    
    context "GET" do
      
      setup do
        get :jquery_autocomplete, :q => 'Test', :format => 'json'
      end
      
      before_should "build the search model" do
        Search.expects(:new).with({:term => 'Test'}, :autocomplete => true).returns @search
      end
      
      should respond_with_content_type 'application/json'
      
    end
    
  end
    
end