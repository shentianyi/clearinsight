class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all.paginate(:page => params[:page])
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    params=project_params
    params[:tenant_id]=current_user.tenant.id
    @project = Project.new(params)

    respond_to do |format|
      if @project.save
        # format.html { redirect_to invite_people_projects_path(@project), notice: 'Project was successfully created.' }
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_basic
    puts params
    project = Project.new(name: params[:name], description: params[:description])
    if project.save
      project.project_items.create({
                                       user_id: current_user.id,
                                       tenant_id: current_user.tenant.id,
                                       status: ProjectItemStatus::ON_GOING
                                   })
      render :json => {result: true, project_id: project.id, content: 'succ'}
    else
      render :json => {result: false, project_id: '', content: project.errors.messages}
    end
  end

  def invite_people
    if project=Project.find_by_id(params[:project_id])
      if (msg=ProjectUser.invite_people params[:people]).result
        msg.object.each do |pu|
          project.project_users.create(user_id: pu[:user_id], tenant_id: current_user.tenant.id, role: pu[:role])
        end
        render :json => {result: true, project_id: project.id, content: 'succ'}
      else
        render :json => {result: false, project_id: '', content: msg.content}
      end
    else
      render :json => {result: false, project_id: '', content: 'Project没有找到'}
    end
  end

  def add_plan
    if project=Project.find_by_id(params[:project_id])

      if (msg=Plan.add_plan params[:people]).result
        msg.object.each do |pi|
          plan=Plan.new({
                            title: pi[:title], start_time: pi[:start_time], end_time: pi[:end_time],
                            time_span: (pi[:end_time].to_date-pi[:start_time].to_date).to_i + 1
                        })
          plan.taskable=project
          plan.user=current_user
          plan.save
        end
        render :json => {result: true, project_id: project.id, content: 'succ'}
      else
        render :json => {result: false, project_id: '', content: msg.content}
      end

    else
      render :json => {result: false, project_id: '', content: 'Project没有找到'}
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name, :description, :user_id, :status, :tenant_id, :remark)
  end
end
