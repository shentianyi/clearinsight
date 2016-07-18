class Diagram < ApplicationRecord
  attr_accessor :parse_layout

  belongs_to :tenant
  acts_as_tenant(:tenant)

  belongs_to :diagrammable, polymorphic: true
  has_one :node_set, dependent: :destroy
  has_many :nodes, through: :node_set

  before_create :init_node_set
  after_update :parse_layout_data

  private
  def init_node_set
    self.build_node_set(tenant_id: self.tenant_id)
  end

  def parse_layout_data
    if self.parse_layout && self.layout
     JSON.parser(self.layout)[:nodeDataArray].each do |n|
        if node=Node.find_by_id(n[:key])
          node.is_selected=n[:isSelected].present? ? n[:isSelected] : false
          if n[:group].present? && (p=Node.find_by_id(n[:group]))
            node.parent=p
          else
            node.parent=nil
          end
          node.save
        end
      end
    end
  end
end
