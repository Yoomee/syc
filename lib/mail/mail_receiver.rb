#!/usr/bin/env ruby
require 'rubygems'
require 'tmail'
require 'beanstalk-client'

message = $stdin.read
mail = TMail::Mail.parse(message)

if !mail.to.nil?
  BEANSTALK = Beanstalk::Pool.new(['127.0.0.1:11300'])
  BEANSTALK.yput({:to => mail.to.flatten.first.gsub('@yoomeehq.com', ''),
                  :from => mail.from,
                  :body => mail.body,
                  :subject => mail.subject
                  :model => {:class => mail["X-Tramlines-Model"], :id => mail["X-Tramlines-Model-Id"]})
end
