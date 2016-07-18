class Diagram < ApplicationRecord
  belongs_to :tenant
  acts_as_tenant(:tenant)

  belongs_to :diagrammable, polymorphous: true
  has_one :node_set, dependent: destroy
end
