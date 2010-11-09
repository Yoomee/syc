module SearchHelper
  
  def search_heading(found_item, term)
    highlight(found_item.to_s, term.split)
  end
  
  def search_summary(found_item, term)
    highlight(search_summary_text(found_item, term), term.split)
  end
  
  def search_summary_text(found_item, term)
    # Loop through the summary fields until the search term is found.
    found_item.summary_fields.each do |summary_field|
      # Split term and use these to find
      term.split.each do |term_part|
        field_text = strip_tags(found_item.send(summary_field))
        excerpt = excerpt(field_text, term_part)
        return excerpt unless excerpt.nil?
      end
    end
    # If it's not found return the first summary field
    if field = found_item.summary_fields.first
      return strip_tags(found_item.send(field)).first(200)
    else
      ''
    end
  end
  
end