module SettingsHelper
  
  def site_name
    APP_CONFIG['site_name']
  end
  
  def site_slogan
    APP_CONFIG['site_slogan']
  end
  
  def site_url
    url = APP_CONFIG['site_url']
    url = url.match(/^http/) ? url : "http://#{url}"
    url.chomp("/")
  end
  
end