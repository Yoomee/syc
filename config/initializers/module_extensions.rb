class Module

  TRUE_VALUES	=	[true, 1, '1', 't', 'T', 'true', 'TRUE'].to_set
  
  def attr_boolean_writer(*attrs)
    attrs.each do |attr|
      attr = attr.to_s
      define_method "#{attr}=" do |val|
        instance_variable_set("@#{attr}", Module::value_to_boolean(val))
      end
    end
  end

  def value_to_boolean(value)
    if value.is_a?(String) && value.blank?
      false
    else
      TRUE_VALUES.include?(value)
    end
  end
  
end