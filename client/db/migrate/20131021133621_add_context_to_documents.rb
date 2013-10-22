class AddContextToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :context, :string, :default => 'page'
  end

  def self.down
    remove_column :documents, :context
  end
end
