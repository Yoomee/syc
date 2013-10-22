module DocumentsHelper

  def document_tab_heading(tab, selected)
    content_tag(:li, :class => tab == selected ? 'active' : '', :id => "#{tab.parameterize('_')}_documents_tab") do
      link_to tab.titleize, :tab_name => tab
    end
  end
  
end