class SnippetsController < ApplicationController
  
  admin_only :edit, :update
  
  def edit
    @snippet = Snippet.find(params[:id])
  end
  
  def update
    @snippet = Snippet.find(params[:id])
    if @snippet.update_attributes(params[:snippet])
      redirect_to_waypoint
    else
      render :action => 'edit'
    end
  end
  
end