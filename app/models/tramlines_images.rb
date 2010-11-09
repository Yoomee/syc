module TramlinesImages
  
  def self.default_image_location(klass, image_attr_name)
    default_filename = "#{klass.to_s.underscore}_#{image_attr_name.to_s.gsub('_uid', '')}"
    File.exists?("#{RAILS_ROOT}/client/public/dragonfly/defaults/#{default_filename}") ? "client_defaults/#{default_filename}" : "defaults/#{default_filename}"
  end
  
  def self.included(klass)
    image_attrs = klass.column_names.select {|col| col.match(/^.+_uid$/)}
    image_attrs.each do |image_attr|
      klass.image_accessor(image_attr.gsub('_uid', ''))
      default_image = default_image_location(klass, image_attr)
      klass.send(:define_method, image_attr) do
        has_image?(image_attr) ? read_attribute(image_attr) : default_image
      end
    end
  end
  
  def has_image?(image_attr = 'image_uid')
    image_attr = image_attr.to_s
    image_attr = "#{image_attr}_uid" unless image_attr.match(/_uid$/)
    !read_attribute(image_attr).blank?
  end
  
end