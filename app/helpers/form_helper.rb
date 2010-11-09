module FormHelper

  def add_remove_child_javascript
    javascript_tag do
      "var FormHelper = {
        insert_fields: function(container, method, content) {
          var new_id = new Date().getTime();
          var regexp = new RegExp('new_' + method, 'g');          
          container.append(content.replace(regexp, new_id));
        },
        remove_fields: function(link) {
          var delete_field = $(link).parent().find('input[id$=_destroy]')[0];
          if (delete_field) {
            delete_field.value = '1';
          }
          $(link).closest('.fields').hide();
        }
      };"
    end
  end
  
  # Method to render a star to show a field is mandatory
  def star
    "<span class='required'>*</span>"
  end
  
  def add_child_function(container_id, f, method, options = {})
    fields = new_child_fields(f, method, options)
    "FormHelper.insert_fields($('##{container_id}'), '#{method}', '#{escape_javascript(fields)}');"
  end
  
  def new_child_fields(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    form_builder.semantic_fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f})
    end
  end  
  
end