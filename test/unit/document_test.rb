require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < ActiveSupport::TestCase

  should belong_to :member
  
  context "a valid instance" do
    
    setup do
      @document = Factory.build(:document)
    end
    
    should "be_valid" do
      assert_valid @document
    end
    
  end
  
end
