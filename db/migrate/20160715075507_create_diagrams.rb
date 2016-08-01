class CreateDiagrams < ActiveRecord::Migration[5.0]
  def change
    create_table :diagrams do |t|
      t.string :name
      t.integer :diagrammable_id
      t.string :diagrammable_type
      t.text :layout
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
