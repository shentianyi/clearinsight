class Kpis::EntriesController<ApplicationController
  before_action :set_kpi_and_project_item, only: [:details]

  def details
    puts params

    @kpi_entries = Kpi::Entry.generated_details_data @kpi, @project_item

    # if params[:format]=='xlsx'
    #   send_data(KpiEntry.to_total_xlsx(@kpi_entries, @kpi),
    #             :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
    #             :filename => "#{Date.today}-工时详细导出.xlsx")
    # else
    #   render :partial => "kpi_entries/history"
    # end
  end


  private
  def set_kpi_and_project_item
    @kpi = KpiBase.find_by_id(params[:kpi_id])
    @project_item = ProjectItem.find_by_id(params[:project_item_id])
  end
end