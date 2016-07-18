class CreateProjectUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :project_users do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.references :tenant, foreign_key: true
      t.integer :role, :default=>200

      t.timestamps
    end

    add_index :project_users, :role
  end
end
