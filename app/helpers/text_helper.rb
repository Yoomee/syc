module TextHelper

  GOOGLE_VIDEO_PLAYER_STRING = "<embed class='videoPlayer' type='application/x-shockwave-flash' src='http://video.google.com/googleplayer.swf?docId=#ID#&amp;hl=en-GB' flashvars='autoPlay=true&amp;playerMode=mini'>" 
  GOOGLE_VIDEO_URL_RE = %r{http://
    (video\.)?
    google\.
    (co\.[\w]{2} | com)
    /videoplay\?docid=
    (\d+) # This is the ID
  }x

  VIMEO_PLAYER_STRING = "<object width='400' height='300'><param name='allowfullscreen' value='true' /><param name='allowscriptaccess' value='always' /><param name='movie' value='http://vimeo.com/moogaloop.swf?clip_id=#ID#&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1' /><embed src='http://vimeo.com/moogaloop.swf?clip_id=#ID#&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1' type='application/x-shockwave-flash' allowfullscreen='true' allowscriptaccess='always' width='400' height='300'></embed></object>"

  VIMEO_URL_RE = %r{(http://www\. | http:// | www\.)
    vimeo\.com/
    (\d+)  # This is the ID
  }x

  YOUTUBE_PLAYER_STRING = "<object width='425' height='350'><param name='movie' value='http://www.youtube.com/v/#ID#'></param><param name='wmode' value='transparent'></param><embed src='http://www.youtube.com/v/#ID#' type='application/x-shockwave-flash' wmode='transparent' width='425' height='350'></embed></object>"

  YOUTUBE_URL_RE = %r{(http://www\. | http:// | www\.)
    youtube\.com\/watch\?v=
    (\w+) # This is the ID
    [^\s<]+
  }x
      
  def add_video_players(text)
    add_google_players(add_youtube_players(add_vimeo_players(text)))
  end
  
  def bracket(options = {}, &block)
    out = capture(&block)
    out = case
      when out.blank?
        ''
      when !options.empty?
        content_tag(:span, "(#{out})", options)
      else
        "(#{out})"
    end
    concat(out)
  end

  def contentize(text)
    auto_link(add_video_players(text))
  end

  def simple_format_with_word_truncation(text, length)
    simple_format text.word_truncate(length)
  end

  # Inverse of ActionView::Helpers::TextHelper#simple_format
  def simple_unformat text
    ret = replace_line_breaks text
    ret = replace_p_tags ret
    ret = CGI::unescapeHTML ret
    ret = unescape_spaces ret
    strip_tags ret
  end

  # # Like the Rails _truncate_ helper but doesn't break HTML tags or entities.
  # def truncate_html(text, max_length = 30, ellipsis = "...")
  #   return if text.nil?
  #   doc = Hpricot(text.to_s)
  #   ellipsis_length = Hpricot(ellipsis).inner_text.mb_chars.length
  #   content_length = doc.inner_text.mb_chars.length
  #   actual_length = max_length - ellipsis_length
  #   content_length > max_length ? doc.truncate(actual_length).inner_html : text.to_s
  # end

  def truncate_html(text, max_length = 30, ellipsis = '...')
    return if text.nil?
    text.truncate_html(max_length, ellipsis)
  end

  private
  def add_google_players(text)
    text.gsub(GOOGLE_VIDEO_URL_RE) do
      gv_id = $3
      left, right = $`, $'
      # detect already linked URLs and URLs in the middle of a tag
      if left =~ /<[^>]+$/ && right =~ /^[^>]*>/
        # do not change string; URL is already linked
        $1
      else
        GOOGLE_VIDEO_PLAYER_STRING.gsub(/#ID#/, gv_id)
      end
    end
  end
  
  def add_vimeo_players(text)
    text.gsub(VIMEO_URL_RE) do
      vimeo_id = $2
      left, right = $`, $'
      # detect already linked URLs and URLs in the middle of a tag
      if left =~ /<[^>]+$/ && right =~ /^[^>]*>/
        # do not change string; URL is already linked
        $1
      else
        VIMEO_PLAYER_STRING.gsub(/#ID#/, vimeo_id)
      end
    end
  end
  
  def add_youtube_players(text)
    text.gsub(YOUTUBE_URL_RE) do
      youtube_id = $2
      left, right = $`, $'
      if left =~ /<[^>]+$/ && right =~ /^[^>]*>/
        # do not change string; URL is already linked
        $1
      else
        YOUTUBE_PLAYER_STRING.gsub(/#ID#/, youtube_id)
      end
    end
  end

  def replace_line_breaks text
    text.gsub(/\<br\s*\>/, "\n")
  end

  def replace_p_tags text
    text.gsub(/\<\/p\>\<p\>/, "\n\n#{$1}")
  end

  def unescape_spaces text
    text.gsub(/&nbsp;/, ' ')
  end
  
  def was_or_were(n)
    n == 1 ? 'was' : 'were'
  end
 
end
