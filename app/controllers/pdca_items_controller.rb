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
    @pdca_item = PdcaItem.new(pdca_item_params)

    respond_to do |format|
      if @pdca_item.save
        format.html { redirect_to @pdca_item, notice: 'Pdca item was successfully created.' }
        format.json { render :show, status: :created, location: @pdca_item }
      else
        format.html { render :new }
        format.json { render json: @pdca_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pdca_items/1
  # PATCH/PUT /pdca_items/1.json
  def update
    respond_to do |format|
      if @pdca_item.update(pdca_item_params)
        format.html { redirect_to @pdca_item, notice: 'Pdca item was successfully updated.' }
        format.json { render :show, status: :ok, location: @pdca_item }
      else
        format.html { render :edit }
        format.json { render json: @pdca_item.errors, status: :unprocessable_entity }
      end
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
