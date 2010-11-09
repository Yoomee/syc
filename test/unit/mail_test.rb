require File.dirname(__FILE__) + '/../test_helper'
class MailTest < ActiveSupport::TestCase
  
  should_belong_to :mailing
  should_belong_to :recipient
  should_have_db_columns :subject, :plain_body, :html_body
  
  should_validate_presence_of :recipient, :subject, :from
  
  context "a valid instance" do
    
    setup do
      @mail = Factory.build(:mail)
    end
    
    should "save" do
      assert_save @mail
    end
    
    should "have status 'not_sent'" do
      assert @mail.not_sent?
    end
    
  end
  
  context "a sent instance" do
    
    setup do
      @mail = Factory.create(:mail)
      @mail.send_email!
      @mail.reload
    end
    
    should "have status 'sent'" do
      assert @mail.sent?
    end
    
  end
  
end