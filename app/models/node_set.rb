class NodeSet < ApplicationRecord
  belongs_to :diagram
  has_many :nodes
end
