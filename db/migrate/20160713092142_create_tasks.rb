class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :content
      t.string :remark
      t.references :user, foreign_key: true
      t.integer :type
      t.integer :status
      t.string :start_time
      t.string :end_time
      t.datetime :due_time
      t.integer :taskable_id
      t.string :taskable_type

      t.timestamps
    end

    add_index :tasks, :title
    add_index :tasks, :taskable_id
    add_index :tasks, :taskable_type
  end
end
