module ShareHelper
  
  def render_share_link text="Share"
    link_to text, :controller => "share", :action => "new", :model_name => controller_name.to_s.singularize, :id => params[:id]
  end
  
end