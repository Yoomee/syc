module ImageHelper

  def default_image_location(object, image_attr_name)
    return "defaults/doc_#{object.file_ext_description}" if object.is_a?(Document)
    default_filename = "#{object.class.to_s.underscore}_#{image_attr_name.to_s.gsub('_uid', '')}"
    File.exists?("#{RAILS_ROOT}/client/public/dragonfly/defaults/#{default_filename}") ? "client_defaults/#{default_filename}" : "defaults/#{default_filename}"
  end
  
  # e.g image_for(@member, '100x100', :extension => 'png', :class => 'image')
  def image_for(object, img_size, options = {})
    method = options.delete(:method) || :image
    img_size = APP_CONFIG[:photo_resize_geometry] if img_size.blank?
    if method.to_s == "photo" 
      image = object.photo.nil? ? Photo.new.image : object.photo.image
    elsif object.has_image?
      image = object.send(method)
    else
      image = Dragonfly::App[:images].fetch(default_image_location(object, method))
    end
    if !image.nil?
      image = image.process(:thumb, img_size)
      image = image.encode(options.delete(:extension)) if !options[:extension].blank?
      image_url = options.delete(:host).to_s + image.url
      options[:url_only] ? image_url : image_tag(image_url, options)
    else
      ''
    end
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
