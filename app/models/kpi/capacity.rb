module Kpi
  class Capacity<KpiBase
    default_scope { where(code: 'CAPACITY') }



    def build_setting(project_item)
      setting= Kpi::Setting.new(kpi_id: self.id,
                                project_item_id: project_item.id,
                                tenant_id: project_item.tenant_id,
                                name: self.name,
                                unit_string: self.unit_string)
      setting.setting_items.build(name:'理论时间',field_name:'theoretic_time',field_type:'float',field_value:'3600',field_unit_string:'S',html_element_type:'input')
      setting
      setting.targets.build(name:'客户需求产能',value:1,code:'CUSTOM_DEFINE',is_system:true)
      setting

    end

  end
end
