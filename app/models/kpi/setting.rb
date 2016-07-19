module Kpi
  class Setting
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    store_in collection: 'kpi_settings'

    #has_many :targets, class_name: 'Kpi::Target'
    embeds_many :targets, class_name: 'Kpi::Target'
    has_many :entries, class_name: 'Kpi::Entry'

    field :kpi_id, type: Integer
    field :name, type: String
    field :project_item_id, type: Integer
    field :tenant_id, type: Integer

  end
end