class Enquiry < ActiveRecord::Base
  
  has_many :enquiry_fields, :dependent => :destroy
  
  belongs_to :member

  validates_presence_of :form_name

  def form_name=(value)
    self.write_attribute(:form_name, value)
    form_module = "#{value.camelize}Form".constantize
    extend(form_module)
  end
  
  def initialize(attrs = {})
    return super if attrs.nil?
    if attrs[:form_name]
      super(:form_name => attrs.delete(:form_name))
      self.attributes = attrs
    else
      super(attrs)
    end
  end
  
end
