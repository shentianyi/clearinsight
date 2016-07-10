class CreateTenants < ActiveRecord::Migration[5.0]
  def change
    create_table :tenants do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
	add_index :tenants,:user_id
  end
end
