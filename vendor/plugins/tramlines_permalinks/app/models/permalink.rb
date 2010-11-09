class Permalink < ActiveRecord::Base

  belongs_to :model, :polymorphic => true
  validates_presence_of :name
  validates_uniqueness_of :name

  class << self

    def unique_name(text)
      count = 1
      new_text = text
      while exists?(:name => new_text)
        new_text = "#{text}-#{count}"
        count += 1
      end
      new_text
    end

  end

  def name=(value)
    value = value.urlify unless value.nil?
    write_attribute(:name, value)
  end

  def model_path
    "/#{model_type.tableize}/#{model_id}"
  end

end