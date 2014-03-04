class TimeproductsController < ApplicationController
  before_action :set_timeproduct, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:getproductinfo, :updateproduct, :addut, :deleteut, :getresult, :getdecide, :generateorder, :getpn]
  # GET /timeproducts
  # GET /timeproducts.json
  def index
    @timeproducts = Timeproduct.all
    curtime = Time.now
    if !@timeproducts.empty?
      @timeproducts.each do |timeproduct|
        if timeproduct.starttime < curtime &&  curtime < timeproduct.continuedtime
          timeproduct.update_attributes(status: 2)
        elsif curtime < timeproduct.starttime 
          timeproduct.update_attributes(status: 1)
        elsif timeproduct.continuedtime < curtime
          timeproduct.update_attributes(status: 3)
        end
      end
    end
  end
  
  #得到价格和次数
  def getpn
    logger.debug "#{params}"   
    @productinfos = []
    @timeproduct_ids = params[:timeproduct_ids]
    if !@timeproduct_ids.empty?
      @timeproduct_ids.each do |timeproduct_id|
        @timeproduct = Timeproduct.find_by(id: timeproduct_id)
        @aucrecords = Aucrecord.where(timeproduct_id: timeproduct_id).order("bidtime DESC")
        if !@aucrecords.empty?
          productinfo = {timeproduct_id: timeproduct_id, curprice: @aucrecords[0].bidnum, curnum: @aucrecords.length} 
          @productinfos << productinfo
        else
          productinfo = {timeproduct_id: timeproduct_id, curprice: @timeproduct.lowprice, curnum: 0} 
          @productinfos << productinfo
        end
      end
    end
    render json: {msg: @productinfos}
  end

  
  # 生成订单
  def generateorder
    logger.debug "#{params}"
    @timeproduct = Timeproduct.find_by(id: params[:timeproduct_id])
    @aucrecord = Aucrecord.where(timeproduct_id: params[:timeproduct_id]).order("bidtime DESC").limit(2)
    if !@aucrecord.empty?
      curtime = Time.now
      ordernum = curtime.tv_sec
      @productorder = Productorder.find_by(timeproduct_id: params[:timeproduct_id])
      if @productorder.nil?
        Productorder.create(timeproduct_id: params[:timeproduct_id], user_id: @aucrecord[0].user_id, finalprice: @aucrecord[0].bidnum, tradingtime: curtime, ordernum: ordernum)        
        if @aucrecord[0].user_id.to_i == params[:user_id].to_i
          render json: {msg: 1}
          logger.debug "生成了订单"      
        else
          render json: {msg: 2}
          logger.debug "生成了别人的订单"    
        end
      else
        render json: {msg: 3}
        logger.debug "订单已经存在"
      end
    end
  end
  
  #订单页面
  def timeorder
    curtime = Time.now
    if current_user.level == 1
      @aucrecords = Aucrecord.where("user_id = ? and status = ?", current_user.id, 1).select(:timeproduct_id).uniq
      if !@aucrecords.empty?
        @aucrecords.each do |aucrecord|         
          @timeproduct = Timeproduct.find_by(id: aucrecord.timeproduct_id)
          if @timeproduct.continuedtime < curtime
            @curaucrecords = Aucrecord.where("timeproduct_id = ?", @timeproduct.id).order("bidtime DESC").limit(1)
            if @curaucrecords[0].user_id == current_user.id
              @productorder = Productorder.find_by(timeproduct_id: @timeproduct.id)
              if @productorder.nil?
                Productorder.create(timeproduct_id: @timeproduct.id, user_id: current_user.id, finalprice: @curaucrecords[0].bidnum, tradingtime: @timeproduct.continuedtime, ordernum: curtime.tv_sec)
              end
            end
          end
        end
      end
      @productorders = Productorder.where("user_id = ?", current_user.id)       
    elsif current_user.level == 2
      @productorders = Productorder.all
    end    
  end
  
  #判断多个商品是否有价格变动
  def getdecide
    logger.debug "#{params}"
    @result = 0
    @timeproductinfos = params[:timeproductinfos]
    logger.debug "#{@timeproductinfos}"
    if !@timeproductinfos.empty?
      @timeproductinfos.each do |timeproductinfo|
        data = timeproductinfo.split("|")
        @timeproduct = Timeproduct.find_by(id: data[0])
        @aucrecord = Aucrecord.where(timeproduct_id: data[0]).order("bidtime DESC").limit(1)
        if !@timeproduct.nil?
          curtime = Time.now.tv_sec
          entime = @timeproduct.continuedtime.tv_sec
          if curtime >= entime
            @result += 1
          end
        end
        if !@aucrecord.empty?
          if @aucrecord[0].bidnum.to_i == data[1].to_i
            @result += 0
            logger.debug "价格没有变动"
          else
            @result += 1
            logger.debug "价格有变动"
          end
        else
          @result += 0
          logger.debug "暂时没有竞价记录"
        end
      end
    end
    render json: {msg: @result}
  end
  
  #判断单个物品是否有新的价格更新
  def getresult
    logger.debug "#{params}"
    @aucrecord = Aucrecord.where(timeproduct_id: params[:timeproduct_id]).order("bidtime DESC").limit(1)
    if !@aucrecord.empty?
      logger.debug "#{@aucrecord[0].bidnum}"
      if @aucrecord[0].bidnum.to_i == params[:value].to_i
        render json: {msg: 1}
        logger.debug "价格没有变动"
      else
        render json: {msg: 2}
        logger.debug "价格有变动"
      end
    else
      render json: {msg: 3}
      logger.debug "暂时没有竞价记录"
    end
  end
  
  #删除竟宝箱里面的物品
  def deleteut
    logger.debug "#{params}"
    @uidtid = Uidtid.find_by(user_id: params[:user_id], timeproduct_id: params[:timeproduct_id])
    if !@uidtid.nil?
      @uidtid.destroy
      render json: {msg: 1}
    end
  end
  
  # 把物品添加到竟宝箱
  def addut
    logger.debug "#{params}"
    @uidtid = Uidtid.find_by(user_id: params[:user_id], timeproduct_id: params[:timeproduct_id]) 
    if @uidtid.nil?
      Uidtid.create(user_id: params[:user_id], timeproduct_id: params[:timeproduct_id])
      render json: {msg: 1}
      logger.debug "成功添加"
    else
      render json: {msg: 2}
      logger.debug "竟宝箱里面已经含有该产品"
    end
    
  end
    
  # 竟宝箱
  def auctionbox  
    curtime = Time.now
    @timeproducts = []
    @uidtids = current_user.uidtids
    if !@uidtids.empty?
      @uidtids.each do |uidtid|
        @timeproduct = Timeproduct.find_by(id: uidtid.timeproduct_id)
        if !@timeproduct.nil?
          if @timeproduct.starttime < curtime &&  curtime < @timeproduct.continuedtime
            @timeproduct.update_attributes(status: 2)
          elsif curtime < @timeproduct.starttime 
            @timeproduct.update_attributes(status: 1)
          elsif @timeproduct.continuedtime < curtime
            @timeproduct.update_attributes(status: 3)
          end
          @timeproducts << @timeproduct          
        end
      end
    end
    logger.debug "#{@timeproducts}"  
  end
  
  # 每一件商品的具体信息
  def merproduct  
    curtime = Time.now  
    logger.debug "#{params}"
    @timeproduct = Timeproduct.find_by(id: params[:id])
    if @timeproduct.starttime < curtime &&  curtime < @timeproduct.continuedtime
      @timeproduct.update_attributes(status: 2)
    elsif curtime < @timeproduct.starttime 
      @timeproduct.update_attributes(status: 1)
    elsif @timeproduct.continuedtime < curtime
      @timeproduct.update_attributes(status: 3)
    end
    @curaucrecord = Aucrecord.where(timeproduct_id: @timeproduct.id).order("bidtime DESC").limit(1)
    @allaucrecords = Aucrecord.where(timeproduct_id: @timeproduct.id)
    @aucrecords = Aucrecord.where(timeproduct_id: @timeproduct.id).order("bidtime DESC").paginate(page: params[:page] || 1, :per_page => 8)
  end
  
  # 更改物品状态
  def updateproduct
    logger.debug "#{params}"
    @timeproduct = Timeproduct.find_by(id: params[:id])
    logger.debug "#{@timeproduct}"
    if !@timeproduct.nil?      
      if params[:status] == '2'
        @timeproduct.update_attributes(status: 2)
        render json: {:msg => 1, :endtime => @timeproduct.continuedtime.tv_sec}
        logger.debug "状态修改成功"
      elsif params[:status] == '3'
        @timeproduct.update_attributes(status: 3)
        render json: {:msg => 1, :endtime => @timeproduct.continuedtime.tv_sec}
        logger.debug "状态修改成功"
      end  
    end
  end
  
  # 得到物品具体信息
  def getproductinfo
    logger.debug "#{params}"
    @timeproduct = Timeproduct.find_by(id: params[:id])
    if !@timeproduct.nil?
      render json: {timeproduct: @timeproduct}
      logger.debug "得到了数据"
    end 
  end
  
  # 得到所有拍卖的商品
  def allproduct
    @timeproducts = Timeproduct.where("status in(?)", 1..2)
    curtime = Time.now
    if !@timeproducts.empty?
      @timeproducts.each do |timeproduct|
        if timeproduct.starttime < curtime &&  curtime < timeproduct.continuedtime
          timeproduct.update_attributes(status: 2)
        elsif curtime < timeproduct.starttime 
          timeproduct.update_attributes(status: 1)
        elsif timeproduct.continuedtime < curtime
          timeproduct.update_attributes(status: 3)
        end
      end
    end
    @timeproducts = Timeproduct.where("status in(?)", 1..2).paginate(page: params[:page] || 1, :per_page => 8)
    logger.debug "#{@timeproducts[0]}ssss"
    logger.debug "#{!@timeproducts.empty?}"
  end

  # GET /timeproducts/1
  # GET /timeproducts/1.json
  def show
  end

  # GET /timeproducts/new
  def new
    @timeproduct = Timeproduct.new
  end

  # GET /timeproducts/1/edit
  def edit
  end

  # POST /timeproducts
  # POST /timeproducts.json
  def create
    year = timeproduct_params[:"name(1i)"]
    month = timeproduct_params[:"name(2i)"]
    day = timeproduct_params[:"name(3i)"]
    datetime = year+'-'+month+'-'+day
    logger.debug "#{datetime}"
    timeproduct_params[:name] = datetime
      @timeproduct = Timeproduct.new(timeproduct_params)
  
      respond_to do |format|
        if @timeproduct.save
          format.html { redirect_to @timeproduct, notice: '商品成功添加' }
          format.json { render action: 'show', status: :created, location: @timeproduct }
        else
          format.html { render action: 'new' }
          format.json { render json: @timeproduct.errors, status: :unprocessable_entity }
        end
      end      

  end

  # PATCH/PUT /timeproducts/1
  # PATCH/PUT /timeproducts/1.json
  def update
    
    respond_to do |format|
      if @timeproduct.update(timeproduct_params)
        format.html { redirect_to @timeproduct, notice: '商品更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @timeproduct.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timeproducts/1
  # DELETE /timeproducts/1.json
  def destroy
    @timeproduct.destroy
    respond_to do |format|
      format.html { redirect_to timeproducts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timeproduct
      @timeproduct = Timeproduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timeproduct_params
      params.require(:timeproduct).permit(:name, :lowprice, :merprice, :starttime, :continuedtime, :status)
    end
end
