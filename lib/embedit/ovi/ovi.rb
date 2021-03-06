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
#http://share.ovi.com - They have no API so screen scrape probably best solution here

module Embedit
  
  class Ovi
    require 'hpricot'
    
    attr_reader :title, :url, :format
    
    def initialize(url)
      page = Hpricot(open(url))
      @url= url
      work_out_html(page)
      work_out_format(@html)
      @title = page.search("h2.pagetitle").inner_html.strip
    end
    
    def html(size = {})
      @html.gsub!(/height="\d+"/, %{height="#{size[:height]}"}) if size[:height]
      @html.gsub!(/width="\d+"/, %{width="#{size[:width]}"}) if size[:width]
      @html
    end
    
    private
    
    def work_out_html(page)
      @html = page.search("tr#M_sidebar_uimediaembed_uifp1 td input").first.attributes['value'] rescue nil  #We first search for video or audio, if not its got to be image (hopfully)
      if @html.nil?
        @html = page.search("div#M_sidebar_uimediaembed_uiip td input#M_sidebar_uimediaembed_uihtml2").first.attributes['value'].gsub(/<a \S+>/, '').gsub(/<\/a>/, '')  #Follow Embedit convention, images should not be surrounded a a <a href></a>
      end
    end
    
    def work_out_format(html)
      case html
        when /flash\/player\.aspx\?media/ then @format = 'video'
        when /flash\/audioplayer\.aspx\?media/ then @format = 'audio'
        when /<img src/ then @format = 'photo'
      end
    end
    
  end
end