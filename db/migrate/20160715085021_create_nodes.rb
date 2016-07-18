class CreateNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :nodes do |t|
      t.integer :type
      t.string :name
      t.string :code
      t.string :uuid
      t.string :devise_code
      t.boolean :is_selected
      t.references :node_set, foreign_key: true

      t.timestamps
    end
  end
end
