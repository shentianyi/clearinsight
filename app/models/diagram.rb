class Diagram < ApplicationRecord
  belongs_to :tenant
  acts_as_tenant(:tenant)

  belongs_to :diagrammable, polymorphic: true
  has_one :node_set, dependent: :destroy
  has_many :nodes,through: :node_set

  before_create :init_node_set

  private
  def init_node_set
    self.build_node_set(tenant_id: self.tenant_id)
  end
end
