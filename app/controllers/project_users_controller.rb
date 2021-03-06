class ProjectUsersController < ApplicationController
  before_action :set_project_user, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:create]
  before_action :require_project_user_admin, only: [:update, :create, :destroy]

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
    if @project
      if user=User.find_by_email(params[:email])
        unless @project.project_users.where(user_id: user.id).blank?
          return render :json => {result: false, content: "该成员已存在,不可重复添加！"}
        end

        puts params[:role]
        puts '-----------------------------------------'
        project_user=@project.project_users.new(user: user, role: params[:role].to_i)
        respond_to do |format|
          if project_user.save
            # format.html { redirect_to project_user, notice: 'Project User was successfully created.' }
            format.json { render json: {result: true, project: @project, project_user: project_user, content: '成功添加该成员'} }
          else
            render :json => {result: false, content: project_user.errors.messages.values.uniq.join('/')}
          end
        end
      else
        render :json => {result: false, content: "邮箱:#{params[:email]}未注册!"}
      end
    else
      render :json => {result: false, content: 'Project没有找到'}
    end
  end

  # PATCH/PUT /project_users/1
  # PATCH/PUT /project_users/1.json
  def update
    if @project.user==@project_user.user
      return render :json => {result: false, content: '不可更改项目创建者'}
    end

    if current_user==@project_user.user
      return render :json => {result: false, content: '不可更改当前用户'}
    end

    if user=User.find_by_email(params[:email])
      if @project_user.project.project_users.where(user_id: user.id).where.not(id: @project_user.id)
        if @project_user.update({user: user, role: params[:role]})
          render :json => {result: true, project: @project_user, content: '成功更新该成员'}
        else
          render :json => {result: false, content: @project_user.errors.messages.values.uniq.join('/')}
        end
      end
    else
      render :json => {result: false, content: '无效的用户'}
    end
  end

  # DELETE /project_users/1
  # DELETE /project_users/1.json
  def destroy
    if @project.user==@project_user.user
      return render :json => {result: false, content: '不可删除项目创建者'}
    end

    if current_user==@project_user.user
      return render :json => {result: false, content: '不可删除当前用户'}
    end

    if @project_user.destroy
      render :json => {result: true, content: '成功删除该成员'}
    else
      render :json => {result: false, content: @project_user.errors.messages.values.uniq.join('/')}
    end
  end

  private
  def set_project
    @project = Project.find_by_id(params[:project_id])
  end

  def require_project_user_admin
    unless @project.project_user_admin? current_user
      render json: {result: false,  content: '该登陆成员没有权限'}
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project_user
    @project_user = ProjectUser.find_by_id(params[:id])
    @project = @project_user.project if @project_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_user_params
    params.require(:project_user).permit(:user_id, :project_id, :tenant_id, :role)
  end
end
