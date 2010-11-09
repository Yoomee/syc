require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class ItemRelationshipTest < ActiveSupport::TestCase
  
  should_belong_to :item
  should_belong_to :related_item
  
end