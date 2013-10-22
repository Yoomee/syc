class Member < ActiveRecord::Base
  
  validates_confirmation_of :password
  validates_presence_of :email, :forename, :password, :surname
  validates_size_of :image, :maximum => 500.kilobytes, :allow_blank => true
  validates_uniqueness_of :email
  validates_uniqueness_of :username, :allow_blank => true
  validates_email_format_of :email

  has_many :documents, :dependent => :destroy
  has_many :photo_albums, :as => :attachable, :dependent => :destroy
  has_many :photos, :through => :photo_albums, :dependent => :destroy
  has_many :links, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  has_many :statuses, :dependent => :destroy

  search_attributes %w{forename surname email username company bio}

  add_to_news_feed

  include TramlinesImages

  class << self
    
    extend ActiveSupport::Memoizable
    
    def anon_access_level_with_index(controller_path)
      controller_path = controller_path.underscore
      anon_group = SystemGroup::anons
      anon_group.access_level_with_index(controller_path)
    end
    memoize :anon_access_level_with_index
  
    # Check if member can login
    def authenticate(email_or_username, password)
      return nil if email_or_username.blank?
      member = find_by_email_or_username(email_or_username)
      if member && member.password == password
        return member
      else
        return nil
      end
    end
    
    def find_by_email_or_username(email_or_username)
      find :first, :conditions => ["email=? OR username=?", email_or_username, email_or_username]
    end

    def primary
      find :first, :conditions => ["username=?", 'primary']
    end

    def secondary
      find :first, :conditions => ["username=?", 'secondary']
    end

  end

  # Gets the full name of the member
  def full_name
    if (forename != '' && surname != '')
      forename+' '+surname
    elsif (forename != '')
      forename
    elsif (email != '')
      email
    end
  end
  alias_method :to_s, :full_name

  def is_primary?
    self == Member.primary
  end

  def is_primary_or_secondary?
    is_primary? || is_secondary?
  end

  def is_secondary?
    self == Member.secondary
  end

  def not_primary_or_secondary?
    !is_primary_or_secondary?
  end

  def status
    statuses.latest.limit(1).first
  end

end
