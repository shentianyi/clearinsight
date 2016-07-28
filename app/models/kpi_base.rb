class KpiBase < ApplicationRecord
  self.table_name='kpis'

  def self.create_settings(project_item)
    Kpi::CycleTime.first.build_setting(project_item).save
    Kpi::HumanCapacity.first.build_setting(project_item).save
  end

  def self.destroy_settings(project_item)
    if setting= Kpi::CycleTime.first.setting(project_item)
      setting.destroy
    end
    if setting= Kpi::HumanCapacity.first.setting(project_item)
      setting.destroy
    end
  end


  def self.settings(project_item)
    settings={}
    ct=Kpi::CycleTime.first
    settings[ct.code] =ct.setting(project_item)

    hc=Kpi::HumanCapacity.first
    settings[hc.code]=hc.setting(project_item)

    settings
  end


  def build_setting(project_item)
    Kpi::Setting.new(kpi_id: self.id, project_item_id: project_item.id, tenant_id: project_item.tenant_id, name: self.name,unit_string:self.unit_string)
  end

  def setting(project_item)
    Kpi::Setting.where(kpi_id: self.id, project_item_id: project_item.id).first
  end
end
