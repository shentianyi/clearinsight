module Kpi
  class Entry
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    belongs_to :setting, class: 'Kpi::Setting'


    field :kpi_id, type: Integer
    field :project_item_id, type: Integer
    field :tenant_id, type: Integer
    field :node_id, type: Integer
    field :node_code, type: String
    field :node_uuid, type: String
    field :value, type: BigDecimal
    field :entry, type: DateTime
  end
end