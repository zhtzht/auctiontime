class ProductordersController < ApplicationController
  before_action :set_productorder, only: [:show, :edit, :update, :destroy]

  # GET /productorders
  # GET /productorders.json
  def index
    @productorder = Productorder.all
  end

  # GET /productorders/1
  # GET /productorders/1.json
  def show
  end

  # GET /productorders/new
  def new
    @productorder = Productorder.new
  end

  # GET /productorders/1/edit
  def edit
  end

  # POST /productorders
  # POST /productorders.json
  def create
    @productorder = Productorder.new(productorder_params)

    respond_to do |format|
      if @productorder.save
        format.html { redirect_to @productorder, notice: 'Productorder was successfully created.' }
        format.json { render action: 'show', status: :created, location: @productorder }
      else
        format.html { render action: 'new' }
        format.json { render json: @productorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productorders/1
  # PATCH/PUT /productorders/1.json
  def update
    respond_to do |format|
      if @productorder.update(productorder_params)
        format.html { redirect_to @productorder, notice: 'Productorder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @productorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productorders/1
  # DELETE /productorders/1.json
  def destroy
    @productorder.destroy
    respond_to do |format|
      format.html { redirect_to productorders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_productorder
      @productorder = Productorder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def productorder_params
      params.require(:productorder).permit(:timeproduct_id, :user_id, :finalprice, :tradingtime, :status, :ordernum)
    end
end
