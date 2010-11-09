module WaypointsHelper
  
  def link_to_waypoint(name = nil, &block)
    # don't want to link to current page
    new_waypoint = current_page?(waypoint) ? home_url : waypoint
    if block_given?
      link_to(new_waypoint, yield)
    else
      link_to(name, new_waypoint)
    end
  end
  
end