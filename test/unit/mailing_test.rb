require File.dirname(__FILE__) + '/../test_helper'
class MailingTest < ActiveSupport::TestCase
  
  should_have_many :mails
  
end