class Kpis::EntriesController<ApplicationController
  before_action :set_project_item, only: [:index, :export]
  before_action :set_kpi, only: [:index, :export]
  before_action :set_entry, only: [:destroy]

  def index
    @kpi_entries = Kpi::Entry.generated_details_data @kpi, @project_item
  end

  def export
    @kpi_entries = Kpi::Entry.generated_details_data @kpi, @project_item

    send_data(Kpi::Entry.to_total_xlsx(@kpi_entries, @kpi),
              :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
              :filename => "#{Date.today}-测试数据详细导出.xlsx")
  end

  def destroy
    if @entry.destroy
      render :json => {result: true, content: '成功删除'}
    else
      render :json => {result: false, content: @entry.errors.messages.values.join('/')}
    end
  end

  def show

  end


  private
  def set_entry
    @entry = Kpi::Entry.where(id: params[:id]).first
  end

  def set_kpi
    @kpi = KpiBase.find_by_code('CYCLE_TIME')
  end

  def set_project_item
    @project_item = ProjectItem.find_by_id(params[:project_item_id])
  end
end