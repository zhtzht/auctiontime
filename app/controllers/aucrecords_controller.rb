class AucrecordsController < ApplicationController
  before_action :set_aucrecord, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:getaucrecord, :generateaucr]
  # GET /aucrecords
  # GET /aucrecords.json
  def index
    @aucrecords = Aucrecord.all
  end

  # GET /aucrecords/1
  # GET /aucrecords/1.json
  def show
  end
  
  # 生成竞拍记录
  def generateaucr
    logger.debug "#{params}"
    curtime = Time.now
    @aucrecord = Aucrecord.where(timeproduct_id: params[:timeproduct_id]).order("bidtime DESC").limit(1)
    if !@aucrecord.empty?
      if @aucrecord[0].user_id.to_i == params[:user_id].to_i
        render json: {msg: 2}
        logger.debug "2次不间隔出价"
      else
        Aucrecord.create(user_id: params[:user_id], bidtime: curtime, bidnum: params[:bidnum], timeproduct_id: params[:timeproduct_id] )
        render json: {msg: 1}
        logger.debug "竞拍记录生成成功"        
      end
    else
      Aucrecord.create(user_id: params[:user_id], bidtime: curtime, bidnum: params[:bidnum], timeproduct_id: params[:timeproduct_id] )
      render json: {msg: 1}
      logger.debug "竞拍记录生成成功"      
    end
  end
  
  # 查询竞拍记录
  def getaucrecord
    logger.debug "#{params}"
    @aucrecord = Aucrecord.where(timeproduct_id: params[:timeproduct_id]).order("bidtime DESC").limit(1)
    render json: {aucrecord: @aucrecord[0]}
  end
  
  # GET /aucrecords/new
  def new
    @aucrecord = Aucrecord.new
  end

  # GET /aucrecords/1/edit
  def edit
  end

  # POST /aucrecords
  # POST /aucrecords.json
  def create
    @aucrecord = Aucrecord.new(aucrecord_params)

    respond_to do |format|
      if @aucrecord.save
        format.html { redirect_to @aucrecord, notice: 'Aucrecord was successfully created.' }
        format.json { render action: 'show', status: :created, location: @aucrecord }
      else
        format.html { render action: 'new' }
        format.json { render json: @aucrecord.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aucrecords/1
  # PATCH/PUT /aucrecords/1.json
  def update
    respond_to do |format|
      if @aucrecord.update(aucrecord_params)
        format.html { redirect_to @aucrecord, notice: 'Aucrecord was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @aucrecord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aucrecords/1
  # DELETE /aucrecords/1.json
  def destroy
    @aucrecord.destroy
    respond_to do |format|
      format.html { redirect_to aucrecords_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aucrecord
      @aucrecord = Aucrecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aucrecord_params
      params.require(:aucrecord).permit(:timeproduct_id, :bidnum, :user_id, :bidtime, :status)
    end
end
