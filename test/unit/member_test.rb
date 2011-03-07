require File.dirname(__FILE__) + '/../test_helper'
class MemberTest < ActiveSupport::TestCase

  should have_db_column(:bio)
  should have_db_column(:company)
  should have_db_column(:created_at)
  should have_db_column(:email)
  should have_db_column(:forename)
  should have_db_column(:id)
  should have_db_column(:image_uid)
  should have_db_column(:password)
  should have_db_column(:surname)
  should have_db_column(:updated_at)
  should have_db_column(:username)

  should validate_presence_of(:email)
  should validate_presence_of(:forename)
  should validate_presence_of(:surname)
  should validate_presence_of(:password)

  context "a valid instance" do
    
    setup do
      @member = Factory.build(:member)
    end
    
    should "be_valid" do
      assert_valid @member
    end
    
  end
  
  context "class" do
    
    should "have image_accessor method" do
      assert_respond_to Member, :image_accessor
    end
    
  end

  context "class on call to authenticate with invalid email/username details" do
      
    should "return nil if email_or_username is blank" do
      assert_nil Member.authenticate('', 'pa55w0rd')
    end
      
    should "return nil if email_or_username is not found" do
      Member.expects(:find_by_email_or_username).with('bad').at_least_once.returns nil
      assert_nil Member.authenticate('bad', 'pa55w0rd')
    end

  end
    
  context "class on call to authenticate with valid details" do
      
    setup do
      @member = Factory.create(:member, :password => 'pa55w0rd')
      Member.expects(:find_by_email_or_username).with('good').returns @member
      @result = Member.authenticate('good', 'pa55w0rd')
    end
      
    should "return the member" do
      assert_equal @member, @result
    end
      
  end
    
  context "class on call to authenticate with valid email/username but invalid password" do

    setup do
      @member = Factory.create(:member, :password => 'pa55w0rd')
      Member.expects(:find_by_email_or_username).with('good').at_least_once.returns @member
      @result = Member.authenticate('good', 'password')
    end
      
    should "return nil" do
      assert_nil @result
    end

  end

  context "class on call to find_by_email_or_username do" do
    
    should "find a member if the email or username exists" do
      member = Factory.build(:member)
      Member.expects(:find).with(:first, :conditions => ["email=? OR username=?", 'good', 'good']).returns member
      assert_equal member, Member.find_by_email_or_username('good')
    end
      
    should "not find a member if the email or username doesn't exist" do
      Member.expects(:find).with(:first, :conditions => ["email=? OR username=?", 'good', 'good']).returns nil
      assert_nil Member.find_by_email_or_username('good')
    end
      
  end
  
  context "on call to has_image?" do
    
    should "return false when image_uid is blank" do      
      @member = Factory.build(:member, :image_uid => '')
      assert !@member.has_image?
    end
    
    should "return true when image_uid is not blank" do
      @member = Factory.build(:member, :image_uid => 'my_profile_image')
      assert @member.has_image?
    end
    
  end
  
  context "on call to image_uid" do
    
    should "return database value if one exists" do
      @member = Factory.build(:member, :image_uid => 'my_profile_image')
      assert_equal @member.image_uid, 'my_profile_image'
    end
    
    should "return default image if image_uid value is blank" do
      @member = Factory.build(:member, :image_uid => '')
      if File.exists?("#{RAILS_ROOT}/client/public/dragonfly/defaults/member_image")
        assert_equal @member.image_uid, "client_defaults/member_image"
      else
        assert_equal @member.image_uid, "defaults/member_image"
      end
    end
    
  end
  
  context "on call to to_s" do
    
    should "return the member's full name" do
      @member = Factory.build(:member, :forename => 'John', :surname => 'Smith')
      assert_equal 'John Smith', @member.to_s
    end

  end

end

