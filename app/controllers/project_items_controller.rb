class ProjectItemsController < ApplicationController
  before_action :set_project_item, only: [:show, :update, :edit, :destroy]
  before_action :set_current_operator, only: [:create, :update]

  # GET /project_items
  # GET /project_items.json
  def index
    @project_items = ProjectItem.all
  end

  # GET /project_items/1
  # GET /project_items/1.json
  def show
  end

  # GET /project_items/new
  def new
    @project_item = ProjectItem.new
  end

  # GET /project_items/1/edit
  def edit
  end

  # POST /project_items
  # POST /project_items.json
  def create
    ProjectItem.transaction do
      # if source=ProjectItem.where(id: params[:id], status: ProjectItemStatus::FINISHED).first
      if source=ProjectItem.find_by_id(params[:project_item_id])
        source.update_attributes({status: ProjectItemStatus::FINISHED})
        project=source.project
        @project_item=project.project_items.create({
                                                       user: current_user,
                                                       tenant: current_user.tenant,
                                                       status: ProjectItemStatus::ON_GOING,
                                                       name: project.generate_item_name,
                                                       source_id: source.id
                                                   })

        if source.diagram.layout

          source.nodes.each do |gn|
            node=Node.create({
                                 type: gn.type,
                                 name: gn.name,
                                 code: gn.code,
                                 is_selected: gn.is_selected,
                                 uuid: gn.uuid,
                                 devise_code: gn.devise_code,
                                 node_set: @project_item.node_set,
                                 tenant: current_user.tenant
                             })
          end

          layout=JSON.parse(source.diagram.layout, symbolize_names: true)
          layout[:nodeDataArray].each_with_index do |n, index|
            # if group_node_ids.keys.include?(n[:key])
            #   layout[:nodeDataArray][index][:key] = group_node_ids[n[:key]]
            #   next
            # end

            if node=Node.find_by_id(n[:key])
              # node=Node.create({
              #                      type: source_node.type,
              #                      name: source_node.name,
              #                      code: source_node.code,
              #                      is_selected: source_node.is_selected,
              #                      uuid: source_node.uuid,
              #                      devise_code: source_node.devise_code,
              #                      node_set: @project_item.node_set,
              #                      tenant: current_user.tenant
              #                  })
              child_node=@project_item.nodes.where(uuid: node.uuid).first
              layout[:nodeDataArray][index][:key] = child_node.id
              if parent_node=node.parent
                layout[:nodeDataArray][index][:group] = @project_item.nodes.where(uuid: parent_node.uuid).first.id#group_node_ids[layout[:nodeDataArray][index][:group]]
              end
            end
          end
          puts layout.to_json
          @project_item.diagram.parse_layout=true
          @project_item.diagram.update_attributes({layout: layout.to_json})
        end

        render :json => {
                   result: true,
                   project_item: @project_item,
                   diagram: @project_item.diagram,
                   settings: @project_item.kpi_settings,
                   # nodes: project_item.nodes,
                   content: '成功新建轮次'
               }
      else
        render :json => {result: false, content: '轮次没有找到'}
      end
    end
  end

  # PATCH/PUT /project_items/1
  # PATCH/PUT /project_items/1.json
  def update
    if @project_item.update(rank: params[:rank])
      render json: {user: @project_item, content: '成功更新轮次', result: true}
    else
      render json: {content: @project_item.errors.messages.values.join('/'), result: false}
    end

    # respond_to do |format|
    #   if @project_item.update(project_item_params)
    #     format.html { redirect_to @project_item, notice: 'Project item was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @project_item }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @project_item.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /project_items/1
  # DELETE /project_items/1.json
  def destroy
    @project_item.destroy
    respond_to do |format|
      format.html { redirect_to project_items_url, notice: 'Project item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_current_operator
    User.current_operator=current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project_item
    @project_item = ProjectItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_item_params
    params.require(:project_item).permit(:user_id, :tenant_id, :project_id, :rank, :status, :source_id)
  end
end
