class CreateStaffMembers < ActiveRecord::Migration
  def self.up
    create_table :staff_members do |t|
      t.string :name
      t.text :description
      t.string :image_uid
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :staff_members
  end
end
