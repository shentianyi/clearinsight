class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :compares, :edit, :update, :destroy, :switch]
  before_action :require_project_user_admin, only: [:update, :switch]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects#.paginate(:page => params[:page])
    # @finished_projects=current_user.projects.finished.paginate(:page => params[:page])
    # @projects = Project.all
    # render json: {result: true, project: @projects, content: 'succ'}
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
  # def create
  #   params=project_params
  #   params[:tenant_id]=current_user.tenant.id
  #   @project = Project.new(params)
  #
  #   respond_to do |format|
  #     if @project.save
  #       # format.html { redirect_to invite_people_projects_path(@project), notice: 'Project was successfully created.' }
  #       format.html { redirect_to @project, notice: 'Project was successfully created.' }
  #       format.json { render :show, status: :created, location: @project }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @project.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def create
    # puts params
    @project = Project.new(name: params[:name], description: params[:description])
    @project.user=current_user

    if @project.save
      pi= @project.project_items.first
      render json: {result: true, diagram: pi.diagram, project: @project, settings: pi.kpi_settings, content: '成功新建项目'}
    else
      render :json => {result: false, content: @project.errors.messages.values.uniq.join('/')}
    end

    # respond_to do |format|
    #   if project.save
    #     pi= project.project_items.first
    #     format.html { redirect_to project, notice: 'Project was successfully created.' }
    #     format.json { render json: {result: true, diagram: pi.diagram, project: project, settings: pi.kpi_settings, content: 'succ'} }
    #   else
    #     render :json => {result: false, project: '', content: project.errors.messages}
    #   end
    # end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @project.update({name: params[:name], description: params[:description]})
      render :json => {result: true, project: @project, content: '成功更新项目'}
      # format.html { redirect_to @project, notice: 'Project was successfully updated.' }
      # format.json { render :show, status: :ok, location: @project }
    else
      render :json => {result: false, content: @project.errors.messages.values.uniq.join('/')}
      # format.html { render :edit }
      # format.json { render json: @project.errors, status: :unprocessable_entity }
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

  def switch
    if @project.blank?
      return render :json => {result: false, content: '项目没有找到'}
    end

    if @project.status==ProjectStatus::ON_GOING
      @project.update_attributes(status: ProjectStatus::FINISHED)
    else
      @project.update_attributes(status: ProjectStatus::ON_GOING)
    end

    render json: {result: true, project: @project, content: '状态更改成功'}
  end


  def compares
    @project_items= @project.nil? ? [] : @project.project_items
  end

  private
  def require_project_user_admin
    unless @project.project_user_admin? current_user
      render json: {result: false,  content: '该登陆成员没有权限'}
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name, :description, :user_id, :status, :tenant_id, :remark)
  end
end
