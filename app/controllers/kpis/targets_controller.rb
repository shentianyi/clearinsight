class Kpis::TargetsController<ApplicationController
  before_action :set_kpi_setting, only: [:create, :index, :update, :destroy]
  before_action :set_target, only: [:update, :destroy]

  def index
    render json: @setting.targets
  end

  def create
    @target=@setting.targets.new(target_params)
    # @target.setting=@setting

    if @target.save
      render json:{result:true, object: @target}
    else
      render json: {result:false,content:@target.errors.messages.values.join(';')}
    end
  end

  def update
    if @target.update(target_params)
      render json: @target
    else
      render json: nil
    end
  end

  def destroy
    unless @target.is_system
      @target.destroy
      respond_to do |format|
        # format.json { head :no_content }
        format.json { render json: {result: true} }
      end
    else
      respond_to do |format|
        format.json { render json: {result: false,content:'系统默认目标,不可删除'} }
      end
    end
  end


  private
  def set_kpi_setting
    @setting=Kpi::Setting.find(params[:setting_id])
  end

  def set_target
    p @setting
    p @setting.targets
    @target=@setting.targets.find(params[:id])
  end

  def target_params
    params.require(:target).permit(:name, :value)
  end

end