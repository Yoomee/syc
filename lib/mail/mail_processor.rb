#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), '../../config/environment')
require 'rubygems'
require 'beanstalk-client'
require 'yaml'
beanstalk_config = YAML::load(File.open("#{RAILS_ROOT}/config/beanstalk.yml"))
 
@logger = Logger.new("#{RAILS_ROOT}/log/queue.#{Rails.env}.log")
@logger.level = Logger::INFO
 
BEANSTALK = Beanstalk::Pool.new(beanstalk_config[Rails.env])
 
loop do
  job = BEANSTALK.reserve
  job_hash = job.ybody
  @logger.info("GOT EMAIL from #{job_hash[:from]}")
  mail_handler = MailHandler.new(job_hash)
  mail_handler.process!
  job.delete
end