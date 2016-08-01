class Kpis::SettingItemsController<ApplicationController
  before_action :set_kpi_setting, only: [:create, :index, :update, :destroy]
  before_action :set_setting_item, only: [:update]


  def update
    if @setting_item.update(setting_item_params)
      render json: {result:true,object:@setting_item}
    else
      render json: {result:false,content:@setting_item.errors.full_messages}
    end
  end

  private
  def set_kpi_setting
    @setting=Kpi::Setting.find(params[:setting_id])
  end

  def set_setting_item
    @setting_item=@setting.setting_items.find(params[:id])
  end

  def setting_item_params
    params.require(:setting_item).permit( :field_value)
  end

end