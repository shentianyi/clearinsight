class AddTenantToNodes < ActiveRecord::Migration[5.0]
  def change
    add_reference :nodes, :tenant, foreign_key: true
  end
end
