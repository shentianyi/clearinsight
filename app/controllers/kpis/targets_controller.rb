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
      render json: @target
    else
      render json: nil
    end
  end

  def update
    if @target.update(task_params)
      render json: @target
    else
      render json: nil
    end
  end

  def destroy
    @target.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      # format.json { head :no_content }
      format.json { render json: {result: true} }
    end
  end

  private
  def set_kpi_setting
    @setting=Kpi::Setting.find(params[:setting_id])
  end

  def set_target
    @target=@setting.targets.find(params[:id])
  end

  def target_params
    params.require(:target).permit(:name, :value)
  end
end