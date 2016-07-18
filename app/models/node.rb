class Node < ApplicationRecord
  inheritance_column = :_type_disabled

  belongs_to :node_set
  has_ancestry

end
