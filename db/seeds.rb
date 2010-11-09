# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Member.create!(:forename => 'Si', :surname => 'Wilkins', :email => 'si@yoomee.com', :username => 'si', :password => 'olive123', :is_admin => true)
Member.create!(:forename => 'Andy', :surname => 'Mayer', :email => 'andy@yoomee.com', :username => 'andy', :password => 'olive123', :is_admin => true)
Member.create!(:forename => 'Nicola', :surname => 'Mayer', :email => 'nicola@yoomee.com', :username => 'nicola', :password => 'olive123', :is_admin => true)
Member.create!(:forename => 'Rich', :surname => 'Wells', :email => 'rich@yoomee.com', :username => 'rich', :password => 'olive123', :is_admin => true)
Member.create!(:forename => 'Ian', :surname => 'Mooney', :email => 'ian@yoomee.com', :username => 'ian', :password => 'olive123', :is_admin => true)
Member.create!(:forename => 'Rob', :surname => 'Parvin', :email => 'rob@yoomee.com', :username => 'rob', :password => 'olive123', :is_admin => true)
Member.create!(:forename => 'Matt', :surname => 'Atkins', :email => 'matt@yoomee.com', :username => 'matt', :password => 'olive123', :is_admin => true)
PhotoAlbum.create!(:name => 'System Images', :system_album => true)
Section.create!(:name => "About Us", :view => "normal", :weight => 0)
Section.create!(:name => "News", :view => "latest_stories", :weight => 0)
Page.create!(:title => "About Us", :text => "This is what we are about.", :section_id => 1)