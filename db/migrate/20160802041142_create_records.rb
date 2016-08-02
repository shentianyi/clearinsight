class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.references :user, foreign_key: true
      t.references :tenant, foreign_key: true
      t.integer :recordable_id
      t.string :recordable_type
      t.string :action
      t.integer :logable_id
      t.string :logable_type

      t.timestamps
    end

    add_index :records, :recordable_id
    add_index :records, :logable_id
  end
end
