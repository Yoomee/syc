module Group

  def self.included(klass)
    klass.has_many :members, :through => :memberships, :order => 'surname, forename', :uniq => true
    klass.has_many :memberships, :as => :group, :dependent => :destroy
    klass.validates_presence_of :name
    klass.validates_uniqueness_of :name
  end
    
end
