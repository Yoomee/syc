module LocationHelper
  
  def current_section?(section_id)
    section_id = section_id.id unless section_id.is_a?(Integer) || section_id.nil?
    return false if section_id.nil?
    case
      when @section && @section.id
        section_id==@section.id
      when @page && @page.is_a?(Page) && @page.id
        section_id==@page.section.id
      else
        false
      end
  end
  
  # Depends on @is_home being set in controller
  def is_home?
    @is_home
  end
  
end