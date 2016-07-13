class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.references :user, foreign_key: true
      t.string :status
      t.references :tenant, foreign_key: true
      t.string :remark

      t.timestamps
    end
  end
end
