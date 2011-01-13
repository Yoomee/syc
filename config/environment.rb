# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.load_paths += %W(#{RAILS_ROOT}/client/app/controllers #{RAILS_ROOT}/client/app/models #{RAILS_ROOT}/client/app/helpers #{RAILS_ROOT}/app/workers)

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  config.gem 'rack-cache', :lib => 'rack/cache'
  config.gem 'dragonfly', :version => '0.6.2'
  config.gem 'aasm', :source => 'http://gemcutter.org'
  config.gem 'formtastic', :source => 'http://gemcutter.org'
  config.gem "acts-as-taggable-on", :source => "http://gemcutter.org", :version => '>=2.0.6'
  config.gem 'will_paginate'
  config.gem 'haml'
  config.gem 'hpricot'
  config.gem 'thinking-sphinx', :source => "http://gemcutter.org", :lib => 'thinking_sphinx'
  config.gem 'has_many_polymorphs'
  config.gem 'system_timer' # for memcache-client
  config.gem 'eventmachine' # for memcache-client
  config.gem 'memcache-client', :lib => 'memcache' # for starling  
  config.gem 'starling-starling', :source => "http://gems.github.com/", :lib => 'starling'
  config.gem 'validatable'
  config.gem 'responds_to_parent'
  config.gem 'geokit'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  config.plugins = [:all, :tramlines_ckeditor]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.active_record.default_timezone = :utc
  config.time_zone = 'London'
  
  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  
  client_environment = "#{RAILS_ROOT}/client/config/environment.rb"
  if File.exists?(client_environment)
    require client_environment
    ClientEnvironment.setup(config)
  end

  
end
require "will_paginate"

ApplicationController.send(:helper, :all)
