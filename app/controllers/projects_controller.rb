class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.ongoings.paginate(:page => params[:page])
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
    project = Project.new(name: params[:name], description: params[:description])
    project.user=current_user

    respond_to do |format|
      if project.save
        pi= project.project_items.first
        format.html { redirect_to project, notice: 'Project was successfully created.' }
        format.json { render json: {result: true, diagram: pi.diagram, project: project, settings: pi.kpi_settings, content: 'succ'} }
      else
        render :json => {result: false, project: '', content: project.errors.messages}
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @project.update({name: params[:name], description: params[:description]})
      render :json => {result: true, project: @project, content: 'succ'}
      # format.html { redirect_to @project, notice: 'Project was successfully updated.' }
      # format.json { render :show, status: :ok, location: @project }
    else
      render :json => {result: false, content: @project.errors.messages}
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


  def compares
    @id=params[:id]
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
