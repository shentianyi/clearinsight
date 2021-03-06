class UsersController < ApplicationController
  # skip_before_action :verify_authenticity_token, :only => [:create]
  # skip_before_action :set_current_user_tenant

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    p current_user

    if current_user && current_user.admin?
      @users=User.all.paginate(:page => params[:page])
    else
      render :json => "404 页面未找到"
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: {user: @user, content: '成功创建新用户', result: true}
    else
      render json: {content: @user.errors.messages.values.uniq.join('/'), result: false}
    end
    #   respond_to do |format|
    #     if @user.save
    #       format.html { redirect_to @user, notice: 'User was successfully created.' }
    #       format.json { render :show, status: :created, user: @user }
    #     else
    #       # format.html { render :new }
    #       format.json { render json: @user.errors, status: :unprocessable_entity }
    #     end
    #   end
  end

  def update
    if params[:user][:name].length > 255
      return render json: {content: '成员名称长度不能大于255', result: false}
    end
    if @user.update(user_params.except(:id))
      render json: {user: @user, content: '成功更新用户', result: true}
    else
      render json: {content: @user.errors.messages.values.uniq.join('/'), result: false}
    end
    # respond_to do |format|
    #   if @user.update(user_params.except(:id))
    #     format.html { redirect_to @user, notice: 'User was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @user }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # DELETE /users/1
  # DELETE /users/1.jsonshow.html.erb
  def destroy
    # if @user.is_sys
    #   respond_to do |format|
    #     format.html { redirect_to users_url, notice: 'Sysatem manager can\'t be destroyed.' }
    #     format.json { head :no_content }
    #   end
    # else
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
    # end
  end

  def check_email
    if user=User.find_by_email(params[:email])
      render :json => {result: true, content: 'Valid'}
    else
      render :json => {result: false, content: 'InValid'}
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
  end
end
