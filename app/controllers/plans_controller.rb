class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :set_current_operator, only: [:create, :update]

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.all
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
  end

  # POST /plans
  # POST /plans.json
  def create
    if project=Project.find_by_id(params[:project_id])

      if params[:start_time].present? && params[:end_time].present? && params[:start_time].to_date < params[:end_time].to_date
        plan=Plan.new({
                          title: params[:title],
                          start_time: params[:start_time],
                          end_time: params[:end_time]
                      })
        plan.taskable=project
        plan.user=current_user


        # respond_to do |format|
        if plan.save
          # format.html { redirect_to plan, notice: 'Plan was successfully created.' }
          # format.json {
          render json: {result: true, project: project, plan: plan, content: '成功新建PLAN'}
          # }
        else
          render :json => {result: false, project: '', content: plan.errors.messages.values.uniq.join('/')}
        end
        # end
      else
        render :json => {result: false, project: '', content: "开始日期或结束日期不能为空且开始日期不能大于结束日期"}
      end

    else
      render :json => {result: false, project: '', content: 'Project没有找到'}
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    # respond_to do |format|
    #   if @plan.update(plan_params)
    #     format.html { redirect_to @plan, notice: 'Plan was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @plan }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @plan.errors, status: :unprocessable_entity }
    #   end
    # end

    if @plan.update({title: params[:title], start_time: params[:start_time], end_time: params[:end_time]})
      render :json => {result: true, plan: @plan, content: '成功更新PLAN'}
    else
      render :json => {result: false, content: @plan.errors.messages.values.uniq.join('/')}
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    if @plan.destroy
      render :json => {result: true, content: '成功删除PLAN'}
    else
      render :json => {result: false, content: @plan.errors.messages}
    end
    # respond_to do |format|
    #   format.html { redirect_to plans_url, notice: 'Plan was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
  def set_current_operator
    User.current_operator=current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.require(:plan).permit(:title, :content, :remark, :user_id, :type, :status, :start_time, :end_time, :due_time, :taskable_id, :taskable_type)
  end
end
