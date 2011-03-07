require File.dirname(__FILE__) + '/../test_helper'
class PermalinkTest < ActiveSupport::TestCase
  
  subject {Factory(:permalink)}
  
  should have_db_column(:name).of_type(:string)
  should have_db_column(:model_type).of_type(:string)
  should have_db_column(:model_id).of_type(:integer)

  should belong_to :model
  
  should validate_presence_of :name
  should validate_uniqueness_of :name
  
end
