class AddResultToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :result, :string
  end
end
