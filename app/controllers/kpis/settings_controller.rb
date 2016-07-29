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

  end

  private
  def set_kpis_settings
    @project_item=ProjectItem.find_by_id(params[:project_item_id])
    @settings=@project_item.kpi_settings
  end

  def get_settings_by_project_item(id)
    if project_item = ProjectItem.find_by_id(id)
      settings=Kpi::Setting.where(project_item_id: project_item.id)
      render :json => {result: true, settings: settings, content: 'succ'}
    else
      render :json => {result: false, content: "轮次没有找到！"}
    end
  end

end