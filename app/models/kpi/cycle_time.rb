module Kpi
  class CycleTime<KpiBase
    default_scope { where(code: 'CYCLE_TIME') }

    # def build_setting(project_item)
    #   Kpi::Setting.new(kpi_id: self.id, project_item_id: project_item.id, tenant_id: project_item.tenant_id, name: self.name,unit_string:self.unit_string)
    # end
    #
    # def setting(project_item)
    #   Kpi::Setting.where(kpi_id: self.id, project_item_id: project_item.id).first
    # end

  end
end