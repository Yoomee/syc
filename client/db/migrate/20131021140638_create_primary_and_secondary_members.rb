class CreatePrimaryAndSecondaryMembers < ActiveRecord::Migration
  def self.up
    Member.create(:email => 'primary@yoomee.com', :password => 'coms5]daffiest', :forename => 'Secondary', :surname => 'Aged', :username => 'primary')
    Member.create(:email => 'secondary@yoomee.com', :password => 'lic7!endorsees', :forename => 'Secondary', :surname => 'Aged', :username => 'secondary')
  end

  def self.down
  end
end
