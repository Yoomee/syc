class SearchController < ApplicationController

  def create
    options = {:match_mode => params[:match_mode], :autocomplete => params[:autocomplete]}
    @search = Search.new params[:search], options
    if request.xhr?
      partial_view_path = params[:results_view_path] ? "#{params[:results_view_path]}/" : ""
      return render(:partial => "#{partial_view_path}ajax_search_results", :locals => {:search => @search})
    end
  end

  def jquery_autocomplete
    search = Search.new({:term => params.delete(:q)}, :autocomplete => true)
    results = search.results.map {|result| {:name => "#{result.to_s} (#{result.class})", :url => url_for(result)}}
    results += search.non_sphinx_results.map {|result| {:name => "#{result.form_title} (Enquiry form)", :url => url_for(:controller => 'enquiries', :action => 'new', :id => result.form_name)}}
    render :json => results.to_json
  end

end