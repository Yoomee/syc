require File.dirname(__FILE__) + '/../test_helper'
class SearchTest < ActiveSupport::TestCase
  
  context "a new instance with a term" do
    
    setup do
      @search = Search.new(:term => 'Test')
    end
    
    should "return the term on call to term" do
      assert_equal 'Test', @search.term
    end
    
    should "return the search results" do
      @results = [Factory.build(:page)]
      ThinkingSphinx.expects(:search).with('Test', :match_mode => :all, :exclude_index_prefix => 'autocomplete').returns @results
      assert_equal @results, @search.results
    end
    
  end
  
end