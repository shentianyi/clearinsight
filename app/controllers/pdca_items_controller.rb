class PdcaItemsController < ApplicationController
  before_action :set_pdca_item, only: [:show, :edit, :update, :destroy]
  before_action :set_project_item, only: [:create]
  before_action :set_current_operator, only: [:create, :update]

  # GET /pdca_items
  # GET /pdca_items.json
  def index
    # @pdca_items = PdcaItem.all
    if @project_item=ProjectItem.find_by_id(params[:project_item_id])
      pdca_infos=[]
      @project_item.pdca_items.each do |pdca_item|
        pdca_infos<<{item: pdca_item, owner: pdca_item.owners_info}
      end
      render :json => {result: true, project: @project_item, pdca_items: pdca_infos, content: '成功找到PDCA'}
    else
      render :json => {result: false, content: '轮次没有找到'}
    end
  end

  # GET /pdca_items/1
  # GET /pdca_items/1.json
  def show
  end

  # GET /pdca_items/new
  def new
    @pdca_item = PdcaItem.new
  end

  # GET /pdca_items/1/edit
  def edit
  end

  # POST /pdca_items
  # POST /pdca_items.json
  def create
    if @project_item
      if params[:item].blank? || params[:due_time].blank?
        render :json => {result: false, content: '需改进项和截止日期不能为空'}
      else
        @pdca_item=PdcaItem.new({
                                   title: params[:item],
                                   content: params[:improvement_point],
                                   due_time: params[:due_time],
                                   status: TaskStatus::ON_GOING
                               })
        @pdca_item.taskable=@project_item
        @pdca_item.user=current_user

        params[:emails].uniq.each do |email|
          @pdca_item.task_users.new({task_id: @pdca_item.id, user: User.find_by_email(email)})
        end unless params[:emails].blank?

        # respond_to do |format|
        if @pdca_item.save
          # format.html { redirect_to pdca_item, notice: 'Pdca Item was successfully created.' }
          # format.json {
          render json: {
                     result: true,
                     project_item: @project_item,
                     pdca: @pdca_item,
                     owner: @pdca_item.owners_info,
                     content: '成功创建PDCA'
                 }
          # }
        else
          render :json => {result: false, content: @pdca_item.errors.messages.values.uniq.join('/')}
        end
        # end
      end
    else
      render :json => {result: false, content: 'Project没有找到'}
    end
  end

  # PATCH/PUT /pdca_items/1
  # PATCH/PUT /pdca_items/1.json
  def update
    puts params
    if @pdca_item=PdcaItem.find_by_id(params[:pdca_id])
      if params[:status].blank?
        if @pdca_item.status==TaskStatus::ON_GOING
          if @pdca_item.update_attributes({
                                             title: params[:item],
                                             content: params[:improvement_point],
                                             result: params[:saving],
                                             due_time: params[:due_time],
                                             # status: params[:status],
                                             remark: params[:remark]
                                         })
          else
            return render :json => {result: false, content: @pdca_item.errors.messages.values.uniq.join('/')}
          end

          params[:emails]=[] if params[:emails].blank?
          @pdca_item.task_users.joins(:user).where(users: {email: @pdca_item.accessers.pluck(:email) - params[:emails]}).each do |task_user|
            task_user.destroy
          end

          add_users = params[:emails] - @pdca_item.accessers.pluck(:email)
          add_users.each do |email|
            @pdca_item.task_users.create({task_id: @pdca_item.id, user: User.find_by_email(email)})
          end

        else
          render :json => {result: false, project: '', content: "PDCA状态为:#{TaskStatus.display(@pdca_item.status)},不可编辑！"}
        end
      elsif params[:status].to_i==TaskStatus::DONE
        if @pdca_item.update_attributes({
                                           result: params[:saving],
                                           status: params[:status],
                                           remark: params[:remark]
                                       })
        else
          return render :json => {result: false, content: @pdca_item.errors.messages.values.uniq.join('/')}
        end
      elsif params[:status].to_i==TaskStatus::CANCEL
        if @pdca_item.update_attributes({
                                           status: params[:status],
                                           remark: params[:remark]
                                       })
        else
          return render :json => {result: false, content: @pdca_item.errors.messages.values.uniq.join('/')}
        end
      else
        return render :json => {result: false, project: '', content: '状态码不正确'}
      end
      render json: {
                 result: true,
                 pdca: @pdca_item,
                 owner: @pdca_item.owners_info,
                 content: '成功更新PDCA'
             }
    else
      render :json => {result: false, project: '', content: 'PDCA没有找到'}
    end
  end

  # DELETE /pdca_items/1
  # DELETE /pdca_items/1.json
  def destroy
    @pdca_item.destroy
    respond_to do |format|
      format.html { redirect_to pdca_items_url, notice: 'Pdca item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_current_operator
    User.current_operator=current_user
  end

  def set_project_item
    @project_item=ProjectItem.find_by_id(params[:project_item_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_pdca_item
    @pdca_item = PdcaItem.find_by_id(params[:id])
    @project_item = @pdca_item.taskable
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pdca_item_params
    params.require(:pdca_item).permit(:item, :improvement_point, :saving, :remark, :user_id, :type, :status, :start_time, :end_time, :due_time, :taskable_id, :taskable_type)
  end
end
