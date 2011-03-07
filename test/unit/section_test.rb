require File.dirname(__FILE__) + '/../test_helper'
class SectionTest < ActiveSupport::TestCase
  
  should have_db_column(:name)
  should have_db_column(:weight)
  should have_db_column(:view)
  
  should validate_presence_of :name
  
  should belong_to :parent
  should have_many :children
  should have_many :pages
  
  context "an instance" do
    
    setup do
      @section = Factory.create(:section)
    end
    
    should "return children ordered by weight then creation datetime" do
      child4 = Factory.create(:section, :name => 'Section 4', :parent => @section, :weight => 1)
      child1 = Factory.create(:section, :name => 'Section 1', :parent => @section, :created_at => 1.day.ago)
      child2 = Factory.create(:section, :name => 'Section 2', :parent => @section, :weight => 0)
      child5 = Factory.create(:section, :name => 'Section 5', :parent => @section, :weight => 2)
      child3 = Factory.create(:section, :name => 'Section 3', :parent => @section, :created_at => 1.day.from_now)
      assert_equal [child1, child2, child3, child4, child5], @section.children
    end
    
    should "return pages ordered by weight then creation datetime" do
      page5 = Factory.create(:page, :title => 'Page 5', :section => @section, :weight => 2)
      page2 = Factory.create(:page, :title => 'Page 2', :section => @section, :weight => 0)
      page3 = Factory.create(:page, :title => 'Page 3', :section => @section, :created_at => 1.day.from_now)
      page4 = Factory.create(:page, :title => 'Page 4', :section => @section, :weight => 1)
      page1 = Factory.create(:page, :title => 'Page 1', :section => @section, :created_at => 1.day.ago)
      assert_equal [page1, page2, page3, page4, page5], @section.pages
    end
    
  end
  
  context "class on call to all" do
    
    setup do
      Section.destroy_all
      @heavy_section = Factory.create(:section, :weight => 100)
      @light_section = Factory.create(:section, :weight => 0)
    end
    
    should 'order by weight' do
      assert_equal [@light_section, @heavy_section], Section.all
    end
    
  end
  
  context "class on call to root" do
    
    setup do
      @root_section = Factory.create(:section, :parent => nil)
      @non_root_section = Factory.create(:section, :parent => Factory.create(:section))
      @result = Section.root
    end
    
    should 'not return a non-root section' do
      assert_does_not_contain @result, @non_root_section
    end
    
    should 'return a root section' do
      assert_contains @result, @root_section
    end
    
  end
  
end
