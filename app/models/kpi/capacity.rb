module Kpi
  class Capacity<KpiBase
    default_scope { where(code: 'CAPACITY') }



    def build_setting(project_item)
      setting= Kpi::Setting.new(kpi_id: self.id,
                                project_item_id: project_item.id,
                                tenant_id: project_item.tenant_id,
                                name: self.name,
                                unit_string: self.unit_string)

      v1=3600
      v2=1

                                if project_item.source_project_item
                                 ca_setting=self.setting(project_item.source_project_item)
                                 v1=ca_setting.setting_theoretic_time

                                 v2=ca_setting.target_custom_define

                                     p '******************'
                                                                  p v1
                                                                  p v2
                                                                  p '*******************'
                                end

      setting.setting_items.build(name:'理论时间',field_name:'theoretic_time',field_type:'float',field_value:v1,field_unit_string:'S',html_element_type:'input')

      setting.targets.build(name:'客户需求产能',value:v2,code:'CUSTOM_DEFINE',is_system:true)
      setting

    end

  end
end
