class ProjectItemsController < ApplicationController
  before_action :set_project_item, only: [:show, :edit, :update, :destroy]

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
    # @project_item = ProjectItem.new(project_item_params)
    #
    # respond_to do |format|
    #   if @project_item.save
    #     format.html { redirect_to @project_item, notice: 'Project item was successfully created.' }
    #     format.json { render :show, status: :created, location: @project_item }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @project_item.errors, status: :unprocessable_entity }
    #   end
    # end
    if project=Project.find_by_id(params[:project_id])
      source=project.project_items.last
      project_item=project.project_items.create({
                                       user: current_user,
                                       tenant: current_user.tenant,
                                       status: ProjectItemStatus::ON_GOING,
                                       name: ProjectItem.generate_name,
                                       source_id: source.id
                                   })
      layout=JSON.parse(source.diagram.layout,symbolize_names:true)
      layout[:nodeDataArray].each_with_index do |n, index|
        node=project_item.nodes.create({
                                           type: n[:returnParams][:type],
                                           name: n[:returnParams][:name],
                                           code: n[:returnParams][:code],
                                           is_selected: n[:returnParams][:is_selected],
                                           uuid: n[:returnParams][:uuid],
                                           devise_code: n[:returnParams][:devise_code],
                                           node_set: project_item.node_set,
                                           tenant: current_user.tenant
                                       })
      end

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
