class AddAncestryToNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :ancestry, :string
    add_index :nodes,:ancestry
  end
end
