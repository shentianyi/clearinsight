module Kpi
  class Target
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic
    store_in collection: 'kpi_targets'

    field :name, type: String
    field :value, type: Float

    #belongs_to :setting, class_name: 'Kpi::Setting'
    embedded_in :setting, class_name: 'Kpi::Setting'
  end
end