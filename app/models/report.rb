class Report
  
  attr_accessor :view
  
  DEFAULTS = {:view => 'html'}
  
  def initialize(attrs = {})
    attrs.reverse_merge(DEFAULTS).each do |k, v|
      send("#{k}=", v)
    end
  end
  
  def name
    self.class.to_s.sub(/Report$/, '').underscore
  end
  
  class << self
    
    def fields(*fields)
      define_method(:headings) do
        fields.map do |field|
          if field.is_a?(Array)
            field[1]
          else
            field.to_s.titleize
          end
        end
      end
    end
    
  end
  
  def rows
    []
  end
  
end