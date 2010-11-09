require File.dirname(__FILE__) + '/../test_helper'
class StatusTest < ActiveSupport::TestCase
  
  should_belong_to :member
  
end
