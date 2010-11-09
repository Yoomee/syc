module FlashHelper
  
  def render_flash
    flash.map {|flash_key, flash_value| content_tag(:p, flash_value, :id => flash_key, :onclick => "$(this).fadeOut('slow');")}.join
  end
  
end