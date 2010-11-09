ActiveSupport::Dependencies.module_eval do
  
  def require_or_load_with_client_extensions(file_name, const_path = nil)
    match = file_name.match(/(#{RAILS_ROOT})(\/app\/.*\.rb)/)
    if match 
      client_file_name = "#{match[1]}/client#{match[2]}"
      require_or_load_without_client_extensions(client_file_name, const_path) if File.exists?(client_file_name)
    else
      client_match = file_name.match(/(#{RAILS_ROOT})\/client(\/app\/.*\.rb)/)
      if client_match
        plugin_file_name = Dir["#{client_match[1]}/vendor/plugins/**#{client_match[2]}"].first
        require_or_load_without_client_extensions(plugin_file_name, const_path) if plugin_file_name
      end
    end
    require_or_load_without_client_extensions(file_name, const_path)
  end
  alias_method_chain :require_or_load, :client_extensions
  
end

client_routes_file = "#{RAILS_ROOT}/client/config/routes.rb"
ActionController::Routing::Routes.add_configuration_file(client_routes_file) if File.exists?(client_routes_file)