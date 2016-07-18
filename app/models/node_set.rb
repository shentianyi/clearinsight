class NodeSet < ApplicationRecord
  belongs_to :tenant
  acts_as_tenant(:tenant)

  belongs_to :diagram
  has_many :nodes, dependent: :destroy
end
