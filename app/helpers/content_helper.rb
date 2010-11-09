module ContentHelper
  
  def description_for(object, options = {})
    options[:length] ||= 100
    description = case
      when object.respond_to?(:description)
        object.description
      when object.respond_to?(:summary)
        # Use large value for length, as it will be truncated later
        object.summary(99999)
      when object.respond_to?(:text)
        object.text
      else
        ''
    end
    truncate_html(description, options[:length])
  end
  
end