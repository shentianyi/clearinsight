class AddContentCloumnToRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :content, :string
  end
end
