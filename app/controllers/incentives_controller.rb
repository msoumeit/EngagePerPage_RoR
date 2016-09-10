class IncentivesController < ApplicationController
  before_action :set_incentive, only: [:show, :edit, :update, :destroy]
  # GET /incentives
  # GET /incentives.json
  def index
    @incentives = Incentive.all
  end

  # GET /incentives/1
  # GET /incentives/1.json
  def show
  end

  # GET /incentives/new
  def new
    if (params[:owntype] == "prizes")
      @incentive = Prize.new
    else
      @incentive = Reward.new
    end

  end

  # GET /incentives/1/edit
  def edit
  end

  # POST /incentives
  # POST /incentives.json
  def create
    if (params[:type] == "Prize")
      @incentive = Prize.new(incentive_params)
      @game = Game.find(params[:ownid])
    @game.prizes << @incentive
    else
      @incentive = Reward.new(incentive_params)
      @level = Level.find(params[:ownid])
    @level.rewards << @incentive
    end
    respond_to do |format|
      if @incentive.save
        if (params[:type] == "Prize")
          format.html { redirect_to edit_game_path(@game), notice: 'Incentive was successfully created.' }
        else
          format.html { redirect_to edit_level_path(@level, :game_id => @level.game.id), notice: 'Incentive was successfully created.' }
        end
      #format.json { render action: 'show', status: :created, location: @incentive }
      else
        format.html { render action: 'new' }
        format.json { render json: @incentive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incentives/1
  # PATCH/PUT /incentives/1.json
  def update

    if (@incentive.instance_of?(Prize))
      @game = Game.find(params[:ownid])
    else
      @level = Level.find(params[:ownid])
    end

    respond_to do |format|
      if @incentive.update_attributes(incentive_params)
        @incentive.save
        if (@incentive.instance_of?(Prize))
          format.html { redirect_to edit_game_path(@game), notice: 'Incentive was successfully created.' }
        else
          
          format.html { redirect_to edit_level_path(@level, :game_id => @level.game.id), notice: 'Incentive was successfully created.' }
        end
      end
    end
  end

  # DELETE /incentives/1
  # DELETE /incentives/1.json
  def destroy
    @incentive.destroy
    respond_to do |format|
      format.html { redirect_to incentives_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_incentive
    if (params[:owntype] == "prizes")
      @incentive = Prize.find(params[:id])
    else
      @incentive = Reward.find(params[:id])
    end

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def incentive_params
    if (params[:type] == "Prize")
      params.require(:prize).permit(:title, :code, :expirydate)
    else
      params.require(:reward).permit(:title, :code, :expirydate)
    end

  end
end
