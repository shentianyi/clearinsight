class KpiBase < ApplicationRecord
  self.table_name='kpis'

  def self.create_settings(project_item)
    # Kpi::CycleTime.first.build_setting(project_item).save
    # Kpi::HumanCapacity.first.build_setting(project_item).save
    [Kpi::CycleTime, Kpi::Capacity, Kpi::HumanCapacity].each do |kc|
      kc.first.build_setting(project_item).save
    end

  end

  def self.destroy_settings(project_item)
    [Kpi::CycleTime, Kpi::Capacity, Kpi::HumanCapacity].each do |kc|
      if setting= kc.first.setting(project_item)
        setting.destroy
      end
    end
  end


  def self.settings(project_item)
    settings={}

    [Kpi::CycleTime, Kpi::Capacity, Kpi::HumanCapacity].each do |kc|
       k=kc.first
       settings[k.code] =k.setting(project_item)
    end

    settings
  end


  def build_setting(project_item)
    Kpi::Setting.new(kpi_id: self.id, project_item_id: project_item.id, tenant_id: project_item.tenant_id, name: self.name, unit_string: self.unit_string)
  end

  def setting(project_item)
    Kpi::Setting.where(kpi_id: self.id, project_item_id: project_item.id).first
  end
end
