class ChangeProjectStatusType < ActiveRecord::Migration[5.0]
  def change
    change_column :projects,:status,:integer,default:100
  end
end
