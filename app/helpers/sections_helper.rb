module SectionsHelper
  
  # Month and years should be an array of month-number, year-number pairs
  def month_and_year_option_tags month_and_years, selected_month = nil, selected_year = nil
    month_and_years.inject('') do |ret, month_and_year|
      month = month_and_year[0]
      year = month_and_year[1]
      ret += "<option value='#{year}/#{month}'"
      ret += " selected='selected'" if year == selected_year && month == selected_month
      ret += ">#{Date::MONTHNAMES[month]} #{year}</option>"
    end
  end
  
  def possible_parent_sections?(section = nil)
    !(Section.all - [section]).empty?
  end
  
end