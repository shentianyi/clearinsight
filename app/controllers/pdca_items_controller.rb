class PdcaItemsController < ApplicationController
  before_action :set_pdca_item, only: [:show, :edit, :update, :destroy]

  # GET /pdca_items
  # GET /pdca_items.json
  def index
    @pdca_items = PdcaItem.all
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
    puts params
    if project_item=ProjectItem.find_by_id(params[:project_item_id])
      if params[:item].blank? || params[:due_time].blank?
        render :json => {result: false, project_item: '', content: '需改进项和截止日期不能为空'}
      else
        pdca_item=PdcaItem.new({
                                   title: params[:item],
                                   content: params[:improvement_point],
                                   due_time: params[:due_time],
                                   status: TaskStatus::ON_GOING
                               })
        pdca_item.taskable=project_item
        pdca_item.user=current_user

        params[:emails].each do |email|
          pdca_item.task_users.new({task_id: pdca_item.id, user: User.find_by_email(email)})
        end

        respond_to do |format|
          if pdca_item.save
            # format.html { redirect_to pdca_item, notice: 'Pdca Item was successfully created.' }
            format.json { render json: {result: true, project_item: project_item, pdca: pdca_item, content: 'succ'} }
          else
            render :json => {result: false, project_item: '', content: pdca_item.errors.messages}
          end
        end
      end
    else
      render :json => {result: false, project_item: '', content: 'Project没有找到'}
    end
  end

  # PATCH/PUT /pdca_items/1
  # PATCH/PUT /pdca_items/1.json
  def update
    puts params
    if pdca_item=PdcaItem.find_by_id(params[:pdca_id])
      if params[:status].blank?
        if pdca_item.status==TaskStatus::ON_GOING
          pdca_item.update_attributes({
                                          title: params[:item],
                                          content: params[:improvement_point],
                                          result: params[:saving],
                                          due_time: params[:due_time],
                                          # status: params[:status],
                                          remark: params[:remark]
                                      })
        else
          render :json => {result: false, project: '', content: "PDCA状态为:#{TaskStatus.display(pdca_item.status)},不可编辑！"}
        end
      elsif params[:status]==TaskStatus::DONE
        pdca_item.update_attributes({
                                        result: params[:saving],
                                        status: params[:status],
                                        remark: params[:remark]
                                    })
      elsif params[:status]==TaskStatus::CANCEL
        pdca_item.update_attributes({
                                        status: params[:status],
                                        remark: params[:remark]
                                    })
      else
        render :json => {result: false, project: '', content: '状态码不正确'}
      end
      render :json => {result: false, pdca: pdca_item, content: 'succ'}
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
  # Use callbacks to share common setup or constraints between actions.
  def set_pdca_item
    @pdca_item = PdcaItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pdca_item_params
    params.require(:pdca_item).permit(:item, :improvement_point, :saving, :remark, :user_id, :type, :status, :start_time, :end_time, :due_time, :taskable_id, :taskable_type)
  end
end