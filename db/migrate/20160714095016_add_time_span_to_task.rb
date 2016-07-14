class AddTimeSpanToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :time_span, :integer
  end
end
