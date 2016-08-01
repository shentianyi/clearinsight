class AddNameToProjectItem < ActiveRecord::Migration[5.0]
  def change
    add_column :project_items, :name, :string
  end
end
