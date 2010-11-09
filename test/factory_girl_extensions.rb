Factory.class_eval do
  
  self.definition_file_paths << "#{RAILS_ROOT}/client/test/factories"
  self.definition_file_paths += Dir["#{RAILS_ROOT}/vendor/plugins/**/test/factories"]
  
end