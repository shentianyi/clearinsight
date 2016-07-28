module Kpi
  class SettingItem
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    field :name, type: String
    field :field_name, type: String
    field :field_type, type:String
    field :field_unit_string,type:String
    field :field_value,type:String
    field :html_element_type, type: String

    embedded_in :setting, class_name: 'Kpi::Setting'
  end
end