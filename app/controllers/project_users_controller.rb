class ProjectUsersController < ApplicationController
  before_action :set_project_user, only: [:show, :edit, :update, :destroy]

  # GET /project_users
  # GET /project_users.json
  def index
    @project_users = ProjectUser.all
  end

  # GET /project_users/1
  # GET /project_users/1.json
  def show
  end

  # GET /project_users/new
  def new
    @project_user = ProjectUser.new
  end

  # GET /project_users/1/edit
  def edit
  end

  # POST /project_users
  # POST /project_users
  # ..json
  def create
    if project=Project.find_by_id(params[:project_id])
      if user=User.find_by_email(params[:email])
        project_user=project.project_users.new(user: user, role: params[:role])
        # render :json => {result: true, project_id: project.id, content: 'succ'}

        respond_to do |format|
          if project_user.save
            format.html { redirect_to project_user, notice: 'Project User was successfully created.' }
            format.json { render json: {result: true, project: project, content: 'succ'} }
          else
            render :json => {result: false, project: '', content: project_user.errors.messages}
          end
        end
      else
        render :json => {result: false, project: '', content: "邮箱:#{params[:email]}未注册!"}
      end
    else
      render :json => {result: false, project: '', content: 'Project没有找到'}
    end
  end

  # PATCH/PUT /project_users/1
  # PATCH/PUT /project_users/1.json
  def update
    respond_to do |format|
      if @project_user.update(project_user_params)
        format.html { redirect_to @project_user, notice: 'Project user was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_user }
      else
        format.html { render :edit }
        format.json { render json: @project_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_users/1
  # DELETE /project_users/1.json
  def destroy
    @project_user.destroy
    respond_to do |format|
      format.html { redirect_to project_users_url, notice: 'Project user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_user
      @project_user = ProjectUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_user_params
      params.require(:project_user).permit(:user_id, :project_id, :tenant_id, :role)
    end
end
