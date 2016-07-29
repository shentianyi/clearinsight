class Kpis::SettingsController<ApplicationController

  def index
    get_settings_by_project_item(params[:project_item_id])
  end

  def show
    get_settings_by_project_item(params[:project_item_id])
  end

  private
  def get_settings_by_project_item(id)
    if project_item = ProjectItem.find_by_id(id)
      settings=Kpi::Setting.where(project_item_id: project_item.id)
      render :json => {result: true, settings: settings, content: 'succ'}
    else
      render :json => {result: false, content: "轮次没有找到！"}
    end
  end

end