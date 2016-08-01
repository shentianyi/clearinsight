class Kpis::TargetsController<ApplicationController
  before_action :set_kpi_setting, only: [:create, :index, :update, :destroy]
  before_action :set_target, only: [:update, :destroy]

  def index
    render json: @setting.targets
  end

  def create
    @target=@setting.targets.new(target_params)
    if @target.save
      render json: {result: true, object: @target}
    else
      render json: {result: false, content: @target.errors.messages.values.join(';')}
    end
  end

  def update
    if @target.update(target_params)
      render json: {result: true, object: @target}
    else
      render json: {result: false, content: @target.errors.messages.values.join(';')}
    end
  end

  def destroy

    if @target
      unless @target.is_system
        @target.destroy
        respond_to do |format|
          # format.json { head :no_content }
          format.json { render json: {result: true} }
        end
      else
        respond_to do |format|
          format.json { render json: {result: false, content: '系统默认目标,不可删除'} }
        end
      end
    else
      respond_to do |format|
        format.json { render json: {result: false, content: '未找到操作项,请重试'} }
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
    @target=@setting.targets.where(id: params[:id]).first
  end

  def target_params
    params.require(:target).permit(:name, :value)
  end

end