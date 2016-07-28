class Kpis::SettingsController<ApplicationController

  def index
    if project_item = ProjectItem.find_by_id(params[:project_item_id])
      settings=Kpi::Setting.where(project_item_id: project_item.id)
      render :json => {result: true, settings: settings, content: 'succ'}
    else
      render :json => {result: false, content: "轮次没有找到！"}
    end
  end
end