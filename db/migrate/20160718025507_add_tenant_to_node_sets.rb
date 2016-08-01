class AddTenantToNodeSets < ActiveRecord::Migration[5.0]
  def change
    add_reference :node_sets, :tenant, foreign_key: true
  end
end
