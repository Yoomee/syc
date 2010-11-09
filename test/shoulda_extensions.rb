Shoulda::ActionController::Macros.module_eval do

  def should_delegate(delegate_method, options)
    delegate_object = options[:to]
    object_method = options[:object_method]
    klass = model_class
    if object_method
      should "delegate #{delegate_method} to #{delegate_object}.#{object_method}" do
        instance = klass.new
        instance.expects(delegate_object).at_least_once.returns mock(object_method => true)
        assert instance.send(delegate_method)
      end
      if options.key?(:nil_object_result)
        nil_object_result = options[:nil_object_result]
        nil_object_result_s =  case nil_object_result
           when nil
             'nil'
           when ''
             "''"
           else
             nil_object_result
         end
        should "return #{nil_object_result_s} for #{delegate_method} when #{delegate_object} is nil" do
          instance = klass.new
          instance.expects(delegate_object).at_least_once.returns nil
          assert_equal nil_object_result, instance.send(delegate_method)
        end
      end
    else
      should "delegate #{delegate_method} to #{delegate_object}" do
        instance = klass.new
        instance.expects(delegate_object).at_least_once.returns mock(delegate_method => true)
        assert instance.send(delegate_method)
      end
      if options.key?(:nil_object_result)
        nil_object_result = options[:nil_object_result]
        nil_object_result_s =  case nil_object_result
          when nil
            'nil'
          when ''
            "''"
          else
            nil_object_result
        end
        should "return #{nil_object_result_s} for #{delegate_method} when #{delegate_object} is nil" do
          instance = klass.new
          instance.expects(delegate_object).at_least_once.returns nil
          assert_equal nil_object_result, instance.send(delegate_method)
        end
      end
    end
  end

  def should_have_actions(*actions)
    klass = controller_class
    actions.flatten.each do |action|
      should "have action '#{action}'" do
        assert klass.new.respond_to?(action)
      end
    end
  end
  
  def should_have_admin_only_actions(*actions)
    actions = actions.flatten
    should_have_actions(actions)
    should_have_admin_only_access_actions(actions)
  end
  alias_method :should_have_admin_only_action, :should_have_admin_only_actions

  def should_have_member_only_actions(*actions)
    actions = actions.flatten
    should_have_actions(actions)
    should_have_member_only_access_actions(actions)
  end
  alias_method :should_have_member_only_action, :should_have_member_only_actions
  
  def should_have_owner_only_actions(*actions)
    actions = actions.flatten
    should_have_actions(actions)
    should_have_owner_only_access_actions(actions)
  end
  alias_method :should_have_owner_only_action, :should_have_owner_only_actions
  
  def should_have_open_actions(*actions)
    actions = actions.flatten
    should_have_actions(actions)
    should_have_open_access_actions(actions)
  end
  alias_method :should_have_open_action, :should_have_open_actions
  
  def should_use_ownership_attribute(attribute)
    klass = controller_class
    should "have ownership attribute  '#{attribute.to_s}'" do
      assert_equal attribute, klass.ownership_attribute
    end
  end
  
  def should_use_tiny_mce
    should "use tiny_mce" do
      assert_accepts assign_to(:uses_tiny_mce).with(true), @controller
    end
  end
  
  private
  def model_class
    self.name.gsub(/Test$/, '').constantize
  end
  
  def should_have_admin_only_access_action(action)
    klass = controller_class
    should "only allow admins to call '#{action}'" do
      assert klass.admin_only_action?(action)
    end
  end
  
  def should_have_admin_only_access_actions(*actions)
    actions.flatten.each do |action|
      should_have_admin_only_access_action(action)
    end
  end
  
  def should_have_member_only_access_action(action)
    klass = controller_class
    should "only allow members to call '#{action}'" do
      assert klass.member_only_action?(action)
    end
  end
  
  def should_have_member_only_access_actions(*actions)
    actions.flatten.each do |action|
      should_have_member_only_access_action(action)
    end
  end
  
  def should_have_owner_only_access_action(action)
    klass = controller_class
    should "only allow owners to call '#{action}'" do
      assert klass.owner_only_action?(action)
    end
  end
  
  def should_have_owner_only_access_actions(*actions)
    actions.flatten.each do |action|
      should_have_owner_only_access_action(action)
    end
  end
  
  def should_have_open_access_action(action)
    klass = controller_class
    should "not restrict calls to '#{action}' to only members" do
      assert !klass.member_only_action?(action)
    end
    should "not restrict calls to '#{action}' to only admins" do
      assert !klass.admin_only_action?(action)
    end
    should "not check ownership on calls to '#{action}'" do
      assert !klass.owner_only_action?(action)
    end
  end
  
  def should_have_open_access_actions(*actions)
    actions.flatten.each do |action|
      should_have_open_access_action(action)
    end
  end

end
