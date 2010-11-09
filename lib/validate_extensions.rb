# -----------------------------------------------------------------------
#
# Copyright (c) andymayer.net Ltd, 2007-2008. All rights reserved.
 
# This software was created by andymayer.net and remains the copyright
# of andymayer.net and may not be reproduced or resold unless by prior
# agreement with andymayer.net.
#
# You may not modify, copy, duplicate or reproduce this software, or
# transfer or convey this software or any right in this software to anyone
# else without the prior written consent of andymayer.net; provided that
# you may make copies of the software for backup or archival purposes
# 
# andymayer.net grants you the right to use this software solely
# within the specification and scope of this project subject to the
# terms and limitations for its use as set out in the proposal.
# 
# You are not be permitted to sub-license or rent or loan or create
# derivative works based on the whole or any part of this code
# without prior written agreement with andymayer.net.
# 
# -----------------------------------------------------------------------
module ValidateExtensions

  EMAIL_FORMAT = /^[^\s]+@[^\s]*\.[a-z]{2,}$/
  URL_FORMAT = /((((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp):\/\/)|(www\.)?)+(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(\/[a-zA-Z0-9\&amp;%_\.\/-~-]*)?(?!['"]))|^\s*$/

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def validates_format_is_email_address_of field, options = {}
      options = {:with => EMAIL_FORMAT}.merge options
      validates_format_of field, options
    end
    alias_method :validates_email_format_of, :validates_format_is_email_address_of
    
    def validates_format_is_url_of field, options = {}
      options = {:with => URL_FORMAT}.merge options
      validates_format_of field, options
    end
    alias_method :validates_url_format_of, :validates_format_is_url_of

  end

  def is_email_address? string
    EMAIL_FORMAT.match string
  end

  def is_url? string
    URL_FORMAT.match string
  end

  def validate_format_is_email_address_of attr_names, message = nil, options = {}
    options = {:separator => ','}.merge options
    message = "must be a list of valid email addresses (separated by '#{options[:separator]}')" if message.nil?
    attr_names.each do |attr_name|
      address_array = send(attr_name).split options[:separator]
      errors.add attr_name, message unless address_array.all? {|address| is_email_address? address.strip}
    end
  end

end
