#TODO - Move to TramlinesGuardianContent Plugin

require 'rubygems'
require 'httparty'

class GuardianWorker < Workling::Base
    
  include HTTParty
  
  #TODO - Get the API from a config file
  @api_key='d3j7kywr89nm5tr83sq34bvr'
  
  base_uri 'http://api.guardianapis.com/content'
  default_params :content_type => "article", :api_key => @api_key
  format :xml
  
  class << self
    
    def find(tags)
      ret = []
      response=get("/search?q=#{tags.join('+')}&after=#{last_month}&count=15&filter=/global/article&order-by-date")
      if response['search']['count'] != "0"
        return response['search']['results']['content']
      else
        return nil
      end
    end

    def create_pages_from_guardian_articles(options)
      puts
      puts "Running create_pages_from_guardian_articles"
      last_article = Page.find_last_guardian_article
      #Change to 1.day.ago - 1 Hour used for testing
      if last_article.nil? || last_article.created_at < 1.hour.ago
        puts "Finding Guardian articles"
        articles = find(options[:tags])
        articles.each do |article|
          unless Page.find_by_guardian_content_id(article["id"])
            page = Page.new(:title => article["headline"], 
                            :text => article["type_specific"]["body"], 
                            :intro => article["trail_text"], 
                            :section => Section.articles, 
                            :publish_on => article["publication_date"].to_datetime,
                            :guardian_content_id => article["id"],
                            :guardian_written_by => article["byline"])
            page.photo = Photo.new(:member_id => 1, :photo_album_id => 1, :image => open(article["trail_image"])) unless article["trail_image"].blank?
            page.snippet_summary = article["standfirst"]
            page.save
          end
        end
      end
    end

    def get_item(contentid)
      response = get("/item/#{contentid}")
      return response['content']
    end

    def last_month
      now = DateTime.now - 31.days
      datestring = "#{now.strftime('%Y')}#{now.strftime('%m')}#{now.strftime('%d')}"
      datestring.to_i
    end
  
  end
  
end