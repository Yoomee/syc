require File.dirname(__FILE__) + '/../test_helper'
class PermalinkTest < ActiveSupport::TestCase
  
  subject {Factory(:permalink)}
  
  should_have_db_columns :name, :model_type, :type => :string
  should_have_db_columns :model_id, :type => :integer

  should_belong_to :model
  
  should_validate_presence_of :name
  should_validate_uniqueness_of :name
  
end
