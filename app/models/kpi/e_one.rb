module Kpi
  class EOne<KpiBase
    default_scope { where(code: 'E1') }


    def build_setting(project_item)
      setting= Kpi::Setting.new(kpi_id: self.id,
                                project_item_id: project_item.id,
                                tenant_id: project_item.tenant_id,
                                name: self.name,
                                unit_string: self.unit_string)

      v1=1
      if project_item.source_project_item
        eone_setting=self.setting(project_item.source_project_item)
        v1=eone_setting.setting_standard_time
      end

      setting.setting_items.build(name: '标准工时', field_name: 'standard_time', field_type: 'float', field_value: v1, field_unit_string: 'S', html_element_type: 'input')
      setting
    end

  end
end