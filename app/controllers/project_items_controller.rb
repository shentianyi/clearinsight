class ProjectItemsController < ApplicationController
  before_action :set_project_item, only: [:show, :edit, :update, :destroy, :nodes]

  # GET /project_items
  # GET /project_items.json
  def index
    @project_items = ProjectItem.all
  end

  # GET /project_items/1
  # GET /project_items/1.json
  def show
    ProjectItem.transaction do
      if project=Project.find_by_id(params[:id])
        source=project.project_items.last
        project_item=project.project_items.create({
                                                      user: user,
                                                      tenant: user.tenant,
                                                      status: ProjectItemStatus::ON_GOING,
                                                      name: ProjectItem.generate_name,
                                                      source_id: source.id
                                                  })
        # pdca_result=project_item.create_pdca params[:pdca], current_user
        # if !pdca_result[:result]
        #   return render :json => {result: false, content: pdca_result.content}
        # end

        layout=JSON.parse(source.diagram.layout, symbolize_names: true)
        layout[:nodeDataArray].each_with_index do |n, index|
          if source_node=Node.find_by_id(n[:key])
            node=Node.create({
                                 type: source_node.type,
                                 name: source_node.name,
                                 code: source_node.code,
                                 is_selected: source_node.is_selected,
                                 uuid: source_node.uuid,
                                 devise_code: source_node.devise_code,
                                 node_set: project_item.node_set,
                                 tenant: user.tenant
                             })
            layout[:nodeDataArray][index][:key] = node.id
          end
        end
        puts layout.to_json
        project_item.diagram.update_attributes({layout: layout.to_json})

        render :json => {result: true, project_item: project_item, content: 'succ'}
      else
        render :json => {result: false, content: 'Project没有找到'}
      end
    end
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
      if project=Project.find_by_id(params[:project_id])
        source=project.project_items.last
        project_item=project.project_items.create({
                                                      user: user,
                                                      tenant: user.tenant,
                                                      status: ProjectItemStatus::ON_GOING,
                                                      name: ProjectItem.generate_name,
                                                      source_id: source.id
                                                  })
        # pdca_result=project_item.create_pdca params[:pdca], current_user
        # if !pdca_result[:result]
        #   return render :json => {result: false, content: pdca_result.content}
        # end

        layout=JSON.parse(source.diagram.layout, symbolize_names: true)
        layout[:nodeDataArray].each_with_index do |n, index|
          if source_node=Node.find_by_id(n[:key])
            node=Node.create({
                                 type: source_node.type,
                                 name: source_node.name,
                                 code: source_node.code,
                                 is_selected: source_node.is_selected,
                                 uuid: source_node.uuid,
                                 devise_code: source_node.devise_code,
                                 node_set: project_item.node_set,
                                 tenant: user.tenant
                             })
            layout[:nodeDataArray][index][:key] = node.id
          end
        end
        puts layout.to_json
        project_item.diagram.update_attributes({layout: layout.to_json})

        render :json => {result: true, project_item: project_item, content: 'succ'}
      else
        render :json => {result: false, content: 'Project没有找到'}
      end
    end
  end

  def nodes
    if @project_item.blank? || (nodes = @project_item.nodes).blank?
      render :json => {result: false, content: '轮次没有找到'}
    else
      render :json => {result: true, project_item: @project_item, nodes: @project_item.nodes, content: 'succ'}
    end
  end


  # PATCH/PUT /project_items/1
  # PATCH/PUT /project_items/1.json
  def update
    respond_to do |format|
      if @project_item.update(project_item_params)
        format.html { redirect_to @project_item, notice: 'Project item was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_item }
      else
        format.html { render :edit }
        format.json { render json: @project_item.errors, status: :unprocessable_entity }
      end
    end
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
  # Use callbacks to share common setup or constraints between actions.
  def set_project_item
    @project_item = ProjectItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_item_params
    params.require(:project_item).permit(:user_id, :tenant_id, :project_id, :rank, :status, :source_id)
  end
end
