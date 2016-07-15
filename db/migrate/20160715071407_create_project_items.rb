class CreateProjectItems < ActiveRecord::Migration[5.0]
  def change
    create_table :project_items do |t|
      t.references :user, foreign_key: true
      t.references :tenant, foreign_key: true
      t.references :project, foreign_key: true
      t.integer :rank
      t.integer :status
      t.integer :source_id

      t.timestamps
    end

    add_index :project_items, :rank
    add_index :project_items, :status
    add_index :project_items, :source_id
  end
end
