class Kpis::SettingsController<ApplicationController
  before_action :set_kpis_settings, only: [:edit]

  def index
    get_settings_by_project_item(params[:project_item_id])
  end

  def show
    get_settings_by_project_item(params[:project_item_id])
  end

  def edit
  end

  def update
    # if project_item=ProjectItem.find_by_id(params[:project_item_id])
    #   params[:settings].each do |setting_args|
    #     if setting=Kpi::Setting.where(id: setting_args[:setting_id]).first
    #       #update setting items
    #       setting_args[:setting_items].each do |item_args|
    #         if item_args[:id].blank?
    #           setting.setting_items.create(check_setting_items_params)
    #         else
    #           if item=setting.setting_items.where(id: item_args[:id]).first
    #             item.update_attributes(check_setting_items_params)
    #           end
    #         end
    #       end
    #
    #       #update targets
    #       setting_args[:targets].each do |target_args|
    #         if target_args[:id].blank?
    #           setting.targets.create(check_setting_targets_params)
    #         else
    #           if target=setting.targets.where(id: target_args[:id]).first
    #             target.update_attributes(check_setting_targets_params)
    #           end
    #         end
    #       end
    #
    #     end
    #   end
    #
    #   render :json => {result: true, settings: project_item.kpi_settings, content: 'succ'}
    # else
    #   render :json => {result: false, content: "轮次没有找到！"}
    # end
  end

  private
  def set_kpis_settings
    @project_item=ProjectItem.find_by_id(params[:project_item_id])
    @settings=@project_item.kpi_settings
  end

  def get_settings_by_project_item(id)
    if project_item = ProjectItem.find_by_id(id)
      # settings=Kpi::Setting.where(project_item_id: project_item.id)
      render :json => {result: true, settings: project_item.kpi_settings, project: project_item.project, content: 'succ'}
    else
      render :json => {result: false, content: "轮次没有找到！"}
    end
  end

end