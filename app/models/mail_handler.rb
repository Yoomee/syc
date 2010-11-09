class MailHandler

  ABOVE_THIS_LINE_TEXT = "Reply ABOVE THIS LINE"

  def bounced_email?
    @model.is_a?(Mail) && @subject.match("Mail delivery failed")
  end
  
  def initialize(attributes = {})
    @subject = attributes[:subject] || ''
    @body = attributes[:body] || ''
    @member = attributes[:from].blank? ? nil : Member.find_by_email(attributes[:from])
    @model = get_model(attributes[:model])
    @respone = get_response
  end

  def invalid?
    !valid?
  end
  
  def process!
    return false if invalid?
    return @model.update_attribute(:status, "bounced") if bounced_email?
    case @model.class
    when Member
      @model.update_attribute(:bio, @response)
    else
      true
    end
  end
  
  def valid?
    !@model.nil?
  end
  
  private
  def get_model(model_header)
    #try and get model from X-Tramlines-Model and X-Tramlines-Model-Id headers
    model_class, model_id = model_header.values
    if model_class.blank? || model_id.blank?
      #get mail model from headers in body from bounced email
      model_class = @body.match(/X-Tramlines-Model:\s*(\w+)\s*/)
      model_id = @body.match(/X-Tramlines-Model-Id:\s*(\d+)\s*/)
    end
    @model = model_class.blank? || model_id.blank? ? nil : model_class[1].constantize.find(model_id[1].to_i)
  end
  
  def get_response
    res = @body.match(/(.*)#{ABOVE_THIS_LINE_TEXT}.*/)
    res ? res[1] : nil
  end
  
end