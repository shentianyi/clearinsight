class CreateKpis < ActiveRecord::Migration[5.0]
  def change
    create_table :kpis do |t|
      t.string :name
      t.string :code
      t.text :description
      t.integer :round
      t.integer :direction
      t.integer :unit
      t.string :unit_string
      t.text :formula_text
      t.boolean :is_system

      t.timestamps
    end
    add_index :kpis,:code
  end
end
