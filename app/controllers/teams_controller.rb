class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  # respond_to :html, :js

  # GET /teams
  # GET /teams.json
  def index
    # Team.update
    Team.should_auto_update?
    # @teams = Team.all
    @teams = Team.order(wins: :desc, point_differential: :desc)
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  def update_standings
    # @teams = Team.all.shuffle
    # @teams = Team.update
    case params[:order].to_sym
    when :update_nfl
      @s = Time.now 
      Team.update 
      puts "Elapsed: #{Time.now - @s}"
      @teams = Team.all
    when :randomize
      Team.randomize
      @teams = Team.all
    when :shuffle 
      @teams = Team.all.shuffle
    when :default
      @teams = Team.all
    else
      @teams = Team.all 
    end
    # 
    # render "index" 

    respond_to do |format|
    #   format.html
      format.js
    end
  end


  def update
    # Team.update

  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :wins, :losses, :ties, :user_id)
    end
end
