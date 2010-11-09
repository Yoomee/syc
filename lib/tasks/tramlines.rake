require 'find'

namespace :tramlines do

  task :test do
    errors = %w(tramlines:test:core tramlines:test:client tramlines:test:plugins).collect do |task|
      begin
        Rake::Task[task].invoke
        nil
      rescue => e
        task
      end
    end.compact
    abort "Errors running #{errors.to_sentence(:locale => :en)}!" if errors.any?
  end

  namespace :test do

    Rake::TestTask.new(:core => "db:test:prepare") do |t|
      t.libs << "test"
      t.pattern = 'test/**/*_test.rb'
      t.verbose = true
    end
    Rake::Task['test:core'].comment = "Run the Tramlines core tests"

    Rake::TestTask.new(:client => "db:test:prepare") do |t|
      t.libs << "test"
      t.pattern = 'client/test/**/*_test.rb'
      t.verbose = true
    end
    Rake::Task['test:core'].comment = "Run the Tramlines client tests"
    
    Rake::TestTask.new(:plugins => "db:test:prepare") do |t|
      t.libs << "test"
      t.pattern = 'vendor/plugins/tramlines_*/test/**/*_test.rb'
      t.verbose = true
    end
    Rake::Task['test:core'].comment = "Run the Tramlines plugin tests"
    
  end
    
end