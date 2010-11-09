module ImageHelper
  
  # e.g image_for(@member, ['100x100', :png], :class => 'image')
  def image_for(object, img_options = [], options = {})
    method = options.delete(:method) || :image
    if image = object.send(method)
     image_tag image.url(*img_options), options
    else
     ''
    end
  end
  
  def image_or_photo_for(object, img_options = [], options = {})
    method = %w{image photo}.detect do |meth|
      object.respond_to?(meth) && !object.send(meth).blank?
    end
    if method
      options.merge!(:method => method)
      image_for(object, img_options, options)
    else
      ''
    end
  end
  
  def photo_for(object, img_options = [], options = {})
    options.merge!(:method => :photo)
    image_for(object, img_options, options)
  end
  
end
