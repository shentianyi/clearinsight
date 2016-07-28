module Kpi
  class Capacity<KpiBase
    default_scope { where(code: 'CAPACITY') }



  def build_setting(project_item)
   setting= Kpi::Setting.new(kpi_id: self.id,
    project_item_id: project_item.id,
    tenant_id: project_item.tenant_id,
    name: self.name,
    unit_string: self.unit_string)
    setting.setting_items.build(name:'理论时间',field_name:'theoretic_time',field_type:'float',field_value:'0',field_unit_string:'S',html_element_type:'input')
setting
  end

  end
end
