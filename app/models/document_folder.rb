class DocumentFolder < ActiveRecord::Base

  has_many :documents, :dependent => :destroy, :foreign_key => "folder_id"

  validates_presence_of :name

  named_scope :for_page, :conditions => { :context => 'page' }, :order =>  :name
  named_scope :for_primary, :conditions => { :context => 'primary' }, :order =>  :name
  named_scope :for_secondary, :conditions => { :context => 'secondary' }, :order =>  :name

  default_scope :order => "name ASC"

  def to_s
    name
  end

end
