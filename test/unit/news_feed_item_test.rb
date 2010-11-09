require File.dirname(__FILE__) + '/../test_helper'
class NewsFeedItemTest < ActiveSupport::TestCase
  
  should_belong_to :attachable
  
end