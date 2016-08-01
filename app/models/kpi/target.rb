module Kpi
  class Target
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic
    #  store_in collection: 'kpi_targets'

    field :name, type: String
    field :value, type: Float
    field :code, type: String
    field :is_system, type: Boolean, default: false

    validates_length_of :name, minimum: 1, maximum: 255,message:'名称长度需在1~255范围内'
    validates_numericality_of :value,message:'值必须是数字'
    #belongs_to :setting, class_name: 'Kpi::Setting'
    embedded_in :setting, class_name: 'Kpi::Setting'

    def as_json(options={})
      attrs = super(options)
      attrs['id'] = attrs["_id"].to_s
      attrs
    end
  end
end