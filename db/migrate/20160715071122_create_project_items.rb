class CreateProjectItems < ActiveRecord::Migration[5.0]
  def change
    create_table :project_items do |t|
      t.references :user, foreign_key: true
      t.references :tenant, foreign_key: true
      t.references :project, foreign_key: true
      t.integer :rank
      t.integer :status

      t.timestamps
    end
  end
end
