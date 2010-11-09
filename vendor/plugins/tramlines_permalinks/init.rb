# Include hook code here
%w(controllers helpers models views).each {|path| ActiveSupport::Dependencies.load_once_paths.delete File.join(File.dirname(__FILE__), 'app', path) }

class ActiveRecord::Base
  
  class << self
    
    def has_permalink
      include HasPermalink
    end

  end
  
end

ActionController::Routing::RouteSet::NamedRouteCollection.class_eval do

  private
  def define_named_route_methods_with_permalinks(name, route)
    define_named_route_methods_without_permalinks(name, route)
    # TODO - beware of custom REST actions
    if model_name = model_name(name.to_s)
      named_helper_module_eval("

        def #{url_helper_name(name, 'path')}_with_permalinks(*args)
          args = args.flatten
          get_#{name}_permalink_path(args) || #{url_helper_name(name, 'path')}_without_permalinks(args)
        end
        alias_method_chain :#{url_helper_name(name, 'path')}, :permalinks
        
        def get_#{name}_permalink_path(args)          
          return nil unless args && args.first
          model_instance = get_#{name}_model_instance(args.first)
          model_instance.try(:permalink_path)
        end

        def get_#{name}_model_instance(obj)
          if obj.is_a?(#{model_name})
            obj
          else
            begin
              #{model_name}.find(obj)
            rescue ActiveRecord::RecordNotFound
              nil
            end
          end
        end

      ", __FILE__, __LINE__)
    end
  end
  alias_method_chain :define_named_route_methods, :permalinks

  def model_name(name)
    begin
      model_name = name.camelcase.constantize
      if !(name =~ /^(new|edit)_/) && name.singularize == name && model_name.included_modules.include?(HasPermalink)
        model_name
      else
        nil
      end
    rescue NameError
      # ie. name is not a model
      nil
    rescue ActiveRecord::StatementInvalid
      # Presumably, the table doesn't exist (ie. you might be trying to run the necessary migrations)
      nil
    end
  end
    
  
end

config.middleware.insert_before ActionController::Failsafe, PermalinksHandler
