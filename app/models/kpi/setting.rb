module Kpi
  class Setting
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: 'kpi_settings'

    has_many :targets, class_name: 'Kpi::Target'

    field :kpi_id,type:Integer
    field :name,type:String
    field :project_item_id,type:Integer
    field :tenant_id,type:Integer

  end
end