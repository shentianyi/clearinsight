class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

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
    # @plan = Plan.new(plan_params)
    #
    # respond_to do |format|
    #   if @plan.save
    #     format.html { redirect_to @plan, notice: 'Plan was successfully created.' }
    #     format.json { render :show, status: :created, location: @plan }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @plan.errors, status: :unprocessable_entity }
    #   end
    # end

    if project=Project.find_by_id(params[:project_id])

      if params[:start_time].to_date < params[:end_time].to_date
        plan=Plan.new({
                          title: params[:title],
                          start_time: params[:start_time],
                          end_time: params[:end_time]
                      })
        plan.taskable=project
        plan.user=current_user
        plan.save
        render :json => {result: true, project_id: project.id, content: 'succ'}
      else
        render :json => {result: false, project_id: '', content: "计划：#{params[:name]}开始日期大于结束日期"}
      end

    else
      render :json => {result: false, project_id: '', content: 'Project没有找到'}
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to plans_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.require(:plan).permit(:title, :content, :remark, :user_id, :type, :status, :start_time, :end_time, :due_time, :taskable_id, :taskable_type)
  end
end
