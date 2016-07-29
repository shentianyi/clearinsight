module Kpi
  class Entry
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    store_in collection: 'kpi_entries'

    # belongs_to :setting, class_name: 'Kpi::Setting'


    field :kpi_id, type: Integer
    field :project_item_id, type: Integer
    field :tenant_id, type: Integer
    field :node_id, type: Integer
    field :node_code, type: String
    field :node_uuid, type: String
    # field :value, type: BigDecimal
    field :value,type:Float
    field :entry_at, type: DateTime
  end
end