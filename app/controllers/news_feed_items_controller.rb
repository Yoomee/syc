class NewsFeedItemsController < ApplicationController
  
  admin_only :destroy
  
  def destroy
    @news_feed_item = NewsFeedItem.find params[:id]
    if @news_feed_item.destroy
      flash[:notice] = 'News Feed Item destroyed'
    else
      flash[:error] = 'News Feed Item could not be destroyed'
    end
    redirect_to_waypoint
  end
  
end