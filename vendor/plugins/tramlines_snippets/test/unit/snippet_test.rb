require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class SnippetTest < ActiveSupport::TestCase
  
  should_belong_to :item
  
end