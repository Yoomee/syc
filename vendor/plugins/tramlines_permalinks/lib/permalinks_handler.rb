class PermalinksHandler

  LOG_FILE = "#{RAILS_ROOT}/log/permalinks.log"

  def initialize(app)
    @app = app
    FileUtils::touch LOG_FILE
    @logger = Logger.new(LOG_FILE)
  end

  def call(env)
    # Only search for permalinks when URL has the form /something (ie. only one '/')
    @logger.info("\n*********************")
    @logger.info env['PATH_INFO']
    path_info = env['PATH_INFO'] || env['REQUEST_URI']
    if path_info.match(/^\/[^\/]+$/)
      # Remove leading '/'
      path = path_info.gsub(/^\//, '')
      @logger.info("Searching for permalink #{path}...")
      if permalink = Permalink.find_by_name(path)
        @logger.info "Using path #{permalink.model_path}"
        env['REQUEST_URI'] = permalink.model_path
      else
        @logger.info "No permalink found"
      end
    end
    env['PATH_INFO'] = env['REQUEST_URI']
    @app.call(env)
  end

end
