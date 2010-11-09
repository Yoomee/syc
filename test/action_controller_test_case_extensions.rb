class ActionController::TestCase
  
  class << self

    def should_have_admin_only_actions(*args)
      actions = args.flatten
      klass = controller_class
      actions.each do |action|
        should "have admin action '#{action}'" do
          assert klass::admin_only_action?(action)
        end
        should "respond to '#{action}'" do
          assert klass.new.respond_to?(action)
        end
      end
      
    end
    alias_method :should_have_admin_only_action, :should_have_admin_only_actions
  
  end
  
  def expect_admin
    expect_logged_in_member(:admin_member)
  end
  
  def expect_logged_in_member(factory = :member)
    logged_in_member = Factory.build(factory, :id => 1)
    @controller.expects(:find_logged_in_member).returns logged_in_member
    logged_in_member
  end

  def stub_access
    @controller.stubs(:gate_keep).returns true
  end
  
end
