class NodeSetsController < ApplicationController
  before_action :set_node_set, only: [:show, :edit, :update, :destroy]

  # GET /node_sets
  # GET /node_sets.json
  def index
    @node_sets = NodeSet.all
  end

  # GET /node_sets/1
  # GET /node_sets/1.json
  def show
  end

  # GET /node_sets/new
  def new
    @node_set = NodeSet.new
  end

  # GET /node_sets/1/edit
  def edit
  end

  # POST /node_sets
  # POST /node_sets.json
  def create
    @node_set = NodeSet.new(node_set_params)

    respond_to do |format|
      if @node_set.save
        format.html { redirect_to @node_set, notice: 'Node set was successfully created.' }
        format.json { render :show, status: :created, location: @node_set }
      else
        format.html { render :new }
        format.json { render json: @node_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /node_sets/1
  # PATCH/PUT /node_sets/1.json
  def update
    respond_to do |format|
      if @node_set.update(node_set_params)
        format.html { redirect_to @node_set, notice: 'Node set was successfully updated.' }
        format.json { render :show, status: :ok, location: @node_set }
      else
        format.html { render :edit }
        format.json { render json: @node_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /node_sets/1
  # DELETE /node_sets/1.json
  def destroy
    @node_set.destroy
    respond_to do |format|
      format.html { redirect_to node_sets_url, notice: 'Node set was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node_set
      @node_set = NodeSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_set_params
      params.require(:node_set).permit(:diagram_id)
    end
end
