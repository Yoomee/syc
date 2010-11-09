require 'dragonfly'

app = Dragonfly::App[:attachments]
app.configure_with(Dragonfly::Config::RailsDefaults) do |c|
  c.register_analyser(Dragonfly::Analysis::FileCommandAnalyser)
  c.register_encoder(Dragonfly::Encoding::TransparentEncoder)
  c.datastore.configure do |d|
    d.root_path = "#{RAILS_ROOT}/uploads"
  end
end
Dragonfly.active_record_macro(:attachment, app)

# Set up and configure the dragonfly app
app = Dragonfly::App[:images]
app.configure_with(Dragonfly::Config::RMagickImages)
app.configure do |c|
  c.log = Rails.logger
  c.datastore.configure do |d|
    d.root_path = "#{RAILS_ROOT}/public/dragonfly"
  end
  c.url_handler.configure do |u|
    # u.secret = 'insert some secret here to protect from DOS attacks!'
    u.path_prefix = '/media'
  end
end
Dragonfly.active_record_macro(:image, app)

# Extend ActiveRecord
# This allows you to use e.g.
#   image_accessor :my_attribute
# in your models.
ActiveRecord::Base.extend Dragonfly::ActiveRecordExtensions
# ActiveRecord::Base.register_dragonfly_app(:image, Dragonfly::App[:images])

### Insert the middleware ###
# Where the middleware is depends on the version of Rails
middleware = Rails.respond_to?(:application) ? Rails.application.middleware : ActionController::Dispatcher.middleware
middleware.insert_after Rack::Lock, Dragonfly::Middleware, :images
middleware.insert_after Rack::Lock, Dragonfly::Middleware, :attachments

# # UNCOMMENT THIS IF YOU WANT TO CACHE REQUESTS WITH Rack::Cache
# require 'rack/cache'
# middleware.insert_before Dragonfly::Middleware, Rack::Cache, {
#    :verbose     => true,
#    :metastore   => "file:#{Rails.root}/tmp/dragonfly/cache/meta",
#    :entitystore => "file:#{Rails.root}/tmp/dragonfly/cache/body"
# }

# Modify destroy_attachments to prevent it deleting default images
# Modify save_attachments to prevent it copying default images
module Dragonfly::ActiveRecordExtensions::InstanceMethods
  
  def destroy_attachments
    attachments.each do |attribute, attachment|
      attachment.destroy! unless read_attribute("#{attribute}_uid").blank?
    end
  end
  
  def save_attachments
    attachments.each do |attribute, attachment|
      attachment.save! unless read_attribute("#{attribute}_uid").blank?
    end
  end
  
end

# When an attachment is saved, its previous_uid is destroyed
# We do not want this to happen if its previous_uid is a default image (e.g. link_image)
class Dragonfly::ActiveRecordExtensions::Attachment

  def previous_uid_with_default_check
    return nil if previous_uid_without_default_check.nil?
    if previous_uid_without_default_check.match(/#{parent_model.class.to_s.downcase}_#{attribute_name}/)
      nil
    else
      previous_uid_without_default_check
    end
  end
  alias_method_chain :previous_uid, :default_check
  
end
