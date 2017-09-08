class PoolsController < ApplicationController
  before_action :set_pool, only: [:show, :edit, :update, :destroy]

  # GET /pools
  # GET /pools.json
  def index
    @pools = Pool.all
  end

  # GET /pools/1
  # GET /pools/1.json
  def show
    Team.should_auto_update?
    @users = @pool.users.includes(:teams).sort_by{|x| [x.sort_stat, x.point_differential, x.name]}.reverse
    # @teams = @pool.standings
  end

  # GET /pools/1/update_standings.json
  def update_standings
    Team.update
    @pool = Pool.find(params[:id])
    @users = @pool.users.includes(:teams).sort_by{|x| [x.sort_stat, x.point_differential, x.name]}.reverse
    respond_to do |format|
      format.js
    end

  end

  # GET /pools/new
  def new
    @pool = Pool.new
  end

  # GET /pools/1/edit
  def edit
  end

  # POST /pools
  # POST /pools.json
  def create
    @pool = Pool.new(pool_params)

    respond_to do |format|
      if @pool.save
        format.html { redirect_to @pool, notice: 'Pool was successfully created.' }
        format.json { render :show, status: :created, location: @pool }
      else
        format.html { render :new }
        format.json { render json: @pool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pools/1
  # PATCH/PUT /pools/1.json
  def update
    respond_to do |format|
      if @pool.update(pool_params)
        format.html { redirect_to @pool, notice: 'Pool was successfully updated.' }
        format.json { render :show, status: :ok, location: @pool }
      else
        format.html { render :edit }
        format.json { render json: @pool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pools/1
  # DELETE /pools/1.json
  def destroy
    @pool.destroy
    respond_to do |format|
      format.html { redirect_to pools_url, notice: 'Pool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pool
      @pool = Pool.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pool_params
      params.require(:pool).permit(:name, :long_name, :active, :sort_order)
    end
end
