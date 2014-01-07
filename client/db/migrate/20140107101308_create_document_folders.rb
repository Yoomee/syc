class CreateDocumentFolders < ActiveRecord::Migration
  def self.up
    create_table :document_folders do |t|
      t.string :context,    :default => "page"
      t.string :name

      t.timestamps
    end
    add_index :document_folders, :context
    add_column :documents, :folder_id, :integer
    add_index :documents, :folder_id
  end

  def self.down
    remove_index :documents, :folder_id
    remove_column :documents, :folder_id
    remove_index :document_folders, :context
    drop_table :document_folders
  end
end
