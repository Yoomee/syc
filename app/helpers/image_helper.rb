module ImageHelper
  
  def default_image_for(object, img_size = nil, options = {})
    method = options.delete(:method) || :image
    image = object.default_image(method)
    dragonfly_image_tag(image, options.merge(:img_size => img_size))
  end
  
  def dragonfly_image_tag(image, options = {})
    if image.nil?
      options[:url_only] ? "" : image_tag("", options)
    else
      img_size = options[:img_size] || APP_CONFIG[:photo_resize_geometry]
      image = image.process(:thumb, img_size)
      image = image.encode(options.delete(:extension)) if !options[:extension].blank?
      image_url = options.delete(:host).to_s + image.url
      return image_url if options[:url_only]
      image_tag(image_url, options)
    end
  end
  
  def get_img_size_options(size_string)
    size_string = size_string.is_a?(Array) ? size_string.first : size_string
    res = size_string.blank? ? nil : size_string.match(/(\d+)x?(\d*)/)
    res ? [res[1], res[2]] : [nil, nil]
  end
  
  # e.g image_for(@member, '100x100', :extension => 'png', :class => 'image')
  def image_for(object, img_size = nil, options = {})
    return options[:url_only] ? "" : image_tag("", options) if object.nil?
    method = options.delete(:method) || :image
    assoc = object.class.reflect_on_association(method.to_sym)
    if !assoc.nil? && assoc.klass == Photo
      image = object.send(method).nil? ? Photo.default_image : object.send(method).image
    elsif object.has_image?
      image = object.send(method)
    else
      image = object.default_image(method)
    end
    dragonfly_image_tag(image, options.merge(:img_size => img_size))
  end
  
  def image_or_photo_for(object, img_options = [], options = {})
    method = %w{image photo}.detect do |meth|
      object.respond_to?(meth) # && !object.send(meth).blank?
    end
    if method
      options.merge!(:method => method)
      image_for(object, img_options, options)
    else
      ''
    end
  end
  
  def photo_for(object, img_options = [], options = {})
    options.reverse_merge!(:method => :photo)
    image_for(object, img_options, options)
  end
  alias_method :photo_or_default_for, :photo_for
  
end
