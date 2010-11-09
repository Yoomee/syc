class Video < ActiveRecord::Base
  
  include Media
  include TramlinesImages
  include ValidateExtensions

  search_attributes %w{name description url}

  validates_presence_of :member, :url
  validates_url_format_of :url

  attr_accessor :invalid_url

  def oembed_video
    if changed.include?('url')
      begin
        oembed = Embedit::Media.new(url)
        self.html = oembed.html
        self.image = open(oembed.thumbnail)
        self.name ||= oembed.title
      rescue
        self.invalid_url = true
      end
    end
  end

  def reformatted_html options={}
    ret = self.html
    ret.gsub!(/\s+width="\d+"/, " width='#{options[:width]}' ") if options[:width]
    ret.gsub!(/\s+height="\d+"/, " height='#{options[:height]}' ") if options[:height]
    ret.gsub!("fullscreen=1", "fullscreen=1&amp;autoplay=1") if options[:autoplay]
    ret.gsub!(/<\/object>/, "<param name='wmode' value='#{options[:wmode]}' /></object>") if options[:wmode]
    # Unencode
    CGI.unescapeHTML ret
  end

  def url=(value)
    value = 'http://' + value unless value.blank? || value =~ /^http/
    write_attribute(:url, value)
    oembed_video unless RAILS_ENV.to_sym == :test
  end

  def validate
    if invalid_url
      self.errors.clear
      self.errors.add(:url, "Could not find video.")
    else
      true
    end
  end
    
end
