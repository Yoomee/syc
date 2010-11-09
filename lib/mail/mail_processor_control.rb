require 'rubygems'
require 'daemons'

Daemons.run(File.join(File.dirname(__FILE__), 'mail_processor.rb'))