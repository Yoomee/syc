class StaffMember < ActiveRecord::Base
  
  include TramlinesImages

  validates_presence_of :name, :description, :image

end
