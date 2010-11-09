class Search

  DEFAULT_OPTIONS = {
    :match_mode => :all
  }

  attr_reader :term
  cattr_reader :enquiry_forms
  
  class << self
    
    def possible_models
      ThinkingSphinx::context.indexed_models.map(&:to_s)
    end
    
    def load_enquiry_forms
      @@enquiry_forms = []
      form_modules = []
      Dir["#{RAILS_ROOT}/**/app/models/*_form.rb"].each do |form_file|
        form = form_file.match(/[\/](\w+)\.rb/)[1].to_s.classify.constantize
        if form.included_modules.include?(EnquiryForm)
          form_modules << form
        end
      end
      form_modules.uniq.each do |form|
        enq = Enquiry.new(:form_name => form.to_s.sub(/Form$/, '').downcase)
        @@enquiry_forms << enq
      end
    end
    
  end
  
  load_enquiry_forms
  
  def all_models?
    @models.nil? || models == self.class::possible_models
  end
  
  def empty?
    results.empty?
  end
  
  def id
    object_id
  end
  
  def initialize(attrs = {}, options = {})
    options.symbolize_keys!
    @options = options.reverse_merge(DEFAULT_OPTIONS)
    if @options[:autocomplete]
      @options[:index_prefix] = 'autocomplete'
      @options[:match_mode] = 'extended'
      @term = "^#{attrs[:term]}"
    else
      @options[:exclude_index_prefix] = 'autocomplete'
      @term = attrs[:term]
    end
    attrs.symbolize_keys!
    @models = attrs[:models].reject {|m| m.blank?} if attrs[:models]
  end
  
  def model_classes
    @models.map(&:constantize)
  end

  def models
    @models ||= self.class::possible_models
  end
  
  # Always a new record! Needed for generating routes
  def new_record?
    true
  end
  
  def non_sphinx_results
    enquiry_form_results
  end
  
  def enquiry_form_results
    @contact_form_results ||= get_enquiry_form_results
  end
  
  def get_enquiry_form_results
    @@enquiry_forms.select {|form| form.form_title =~ /#{@term}/i}
  end
  
  def results
    @results ||= get_results
  end
  
  def size
    results.size
  end

  private
  def get_results
    @options[:classes] = model_classes unless all_models?
    term.blank? ? [] : ThinkingSphinx.search(term, @options)
  end
  
end
