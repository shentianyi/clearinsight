class CreateNodeSets < ActiveRecord::Migration[5.0]
  def change
    create_table :node_sets do |t|
      t.references :diagram, foreign_key: true

      t.timestamps
    end
  end
end
