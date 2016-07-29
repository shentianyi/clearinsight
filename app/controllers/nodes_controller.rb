class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]
  before_action :set_diagram, only: [:update, :create]
  before_action :set_project_item, only: [:index]

  # GET /nodes
  # GET /nodes.json
  def index
    # @nodes = Node.all
    if @project_item.blank?
      render :json => {result: false, content: '轮次没有找到'}
    else
      render :json => {
                 result: true,
                 project_item: @project_item,
                 nodes: @project_item.nodes,
                 diagram: @project_item.diagram,
                 settings: @project_item.kpi_settings,
                 content: 'succ'
             }
    end
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(node_params)
    @node.node_set=@diagram.node_set
    respond_to do |format|
      if @node.save
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      if @node.update(node_params)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: @node }
      else
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url, notice: 'Node was successfully destroyed.' }
      # format.json { head :no_content }
      format.json { render json: {result: true} }
    end
  end

  private
  def set_diagram
    @diagram=Diagram.find_by_id(params[:diagram_id])
  end

  def set_project_item
    @project_item=ProjectItem.find_by_id(params[:project_item_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_node
    @node = Node.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def node_params
    params.require(:node).permit(:type, :name, :code, :uuid, :devise_code, :is_selected, :node_set_id)
  end
end
