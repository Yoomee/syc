module HasPermalink
  
  def self.included(klass)
    klass.has_one :permalink, :as => :model, :autosave => true
    klass.extend Forwardable
    klass.def_delegator :get_permalink, :name, :permalink_name
    klass.def_delegator :get_permalink, :name=, :permalink_name=
    klass.before_validation :build_a_permalink    
    klass.before_validation :destroy_permalink_if_blank
    klass.has_virtual_attribute :permalink_name
    klass.after_validation :validate_permalink
  end
  
  # def attributes_with_permalinks
  #   returning out = attributes_without_permalinks do
  #     out['permalink_name'] = permalink_name
  #   end
  # end  
  
  def permalink_path
    # We don't want to use an unsaved value for this, otherwise form actions etc. will break
    (!permalink_name.blank? && !permalink.name_was.blank?) ? "/#{permalink.name_was}" : nil
  end
  
  private  
  def destroy_permalink_if_blank
    permalink.destroy if permalink && permalink_name.blank?
  end
  
  def build_a_permalink
    unless to_s.blank? || (permalink && !permalink.name.blank?)
      self.permalink = build_permalink(:name => Permalink.unique_name(to_s.downcase.urlify))
    end
  end
  
  def get_permalink
    self.permalink ||= build_permalink
  end
  
  def validate_permalink
    if permalink
      permalink.errors.each do |attr, msg|
        errors.add(:permalink_name, msg)
      end
      permalink.errors.clear
    end
  end
  
end