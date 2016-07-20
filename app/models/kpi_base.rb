class KpiBase < ApplicationRecord
  self.table_name='kpi'

  def self.create_settings(project_item)
    Kpi::CycleTime.first.build_setting(project_item).save
  end

  def self.destroy_settings(project_item)
    if setting= Kpi::CycleTime.first.setting(project_item)
      setting.destroy
    end
  end


  def self.settings(project_item)
    settings={}
    ct=Kpi::CycleTime.first
    settings[ct.code] =ct.setting(project_item)
    settings
  end
end
