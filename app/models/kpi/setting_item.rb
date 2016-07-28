module Kpi
  class SettingItem
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    field :name, type: String
    field :field_name, type: String
    field :field_type, type: String
    field :field_unit_string, type: String
    field :field_value, type: String
    field :html_element_type, type: String

    embedded_in :setting, class_name: 'Kpi::Setting'

    def parsed_field_value
      case self.field_type
        when 'string'
          self.field_value
        when 'int'
          self.field_value.to_i
        when 'float'
          self.field_value.to_f
        else
          self.field_value
      end
    end
  end

  def as_json(options={})
    attrs = super(options)
    attrs['id'] = attrs["_id"].to_s
    attrs
  end
end