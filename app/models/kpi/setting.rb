module Kpi
  class Setting
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    store_in collection: 'kpi_settings'

    # acts_as_settingable

    #has_many :targets, class_name: 'Kpi::Target'
    embeds_many :targets, class_name: 'Kpi::Target'
    embeds_many :setting_items, class_name: 'Kpi::SettingItem'
    has_many :entries, class_name: 'Kpi::Entry'

    field :kpi_id, type: Integer
    field :name, type: String
    field :project_item_id, type: Integer
    field :tenant_id, type: Integer

    def method_missing(method_name, *args, &block)
      if /setting_\w+/.match(method_name.to_s)
       if setting= self.setting_items.where(field_name:method_name.to_s.sub(/setting_/, '')).first
         setting.parsed_field_value
       end
      elsif /target_\w+/.match(method_name.to_s)
        if target= self.targets.where(code:method_name.to_s.sub(/target_/, '')).first
          target.value
        end
      else
        super
      end
    end
  end

  def as_json(options={})
    attrs = super(options)
    attrs['id'] = attrs["_id"].to_s
    attrs['setting_items'] =self.setting_items.map { |i|
      i.as_json
    }
    attrs['targets'] =self.targets.map { |i|
      i.as_json
    }
    attrs
  end
end