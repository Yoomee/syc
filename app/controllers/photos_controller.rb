class PhotosController < ApplicationController
  
  member_only :create, :new
  owner_only :edit, :destroy, :update
  
  before_filter :get_photo_album, :only => %w{ajax index new}
  
  def ajax
    @photos = @photo_album.photos
    render(:partial => 'photos', :locals =>{:photos => @photos})
  end
  
  def index
    @photos = @photo_album ? @photo_album.photos : Photo.all
  end
  
  def show      
    @photo = Photo.find(params[:id])
  end
  
  def new
    @photo = Photo.new(:member => @logged_in_member, :album => @photo_album)
  end
  
  def create
    @photo = Photo.new(params[:photo])
    if @photo.save
      flash[:notice] = "Successfully created photo."
      redirect_to @photo
    else
      render :action => 'new'
    end
  end
  
  def edit
    @photo = Photo.find(params[:id])
  end
  
  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = "Successfully updated photo."
      redirect_to @photo
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    flash[:notice] = "Successfully destroyed photo."
    redirect_to photos_url
  end
  
  private
  def get_photo_album
    @photo_album = PhotoAlbum.find(params[:photo_album_id]) if params[:photo_album_id]
  end
end
