module Kpi
  class CycleTime<KpiBase
    default_scope { where(code: 'CYCLE_TIME') }

    def build_setting(project_item)
      Kpi::Setting.new(kpi_id: self.id, project_item_id: project_item.id, tenant_id: project_item.tenant_id, name: self.name)
    end

    def setting(project_item)
      Kpi::Setting.find_by(kpi_id: self.id, project_item_id: project_item.id)
    end


  end
end