class LevelsController < ApplicationController
  before_action :set_level, only: [:show, :edit, :update, :destroy]
  before_action :set_current_user
  impressionist :actions => [:new]
  # GET /levels/1
  # GET /levels/1.json
  def show
  end

  # GET /levels/new
  def new
    @game = Game.friendly.find(params[:id])
    @level = Level.new
    @level.game = @game
    #@puzzle = Puzzle.new
    #@level.puzzle= @puzzle
    @level.build_puzzle
    @puzzle = @level.puzzle
    #@task = Task.new
    #@level.task = @task
    @level.build_task
    @task = @level.task
    @incentives = @level.rewards
    @puzzle.build_picture
    #@picture = @puzzle.picture
  end

  # GET /levels/1/edit
  def edit
    @game = Game.friendly.find(params[:game_id])
    @level = Level.find(params[:id])
    @incentives = @level.rewards
    @owner_id = @level.id
    @ownertype = "rewards"
    @picture = @level.puzzle.picture
    impressionist(@game)
  end

  # POST /levels
  # POST /levels.json
  def create
    @level = Level.new  
    @game = Game.friendly.find(params[:game_id])
    impressionist(@game)
    ActiveRecord::Base.transaction do
    @level.update_attributes level_params  
    
      #@puzzle = @level.create_puzzle(level_params[:puzzle])
      #@task =  @level.create_task(level_params[:task_attributes])
      #@puzzle = @level.puzzle
      #@task =  @level.task
      #@task.source_type = params['task_source_type']
      #if @task.save
        respond_to do |format|
          if @level.persisted?
            @game.levels << @level
            format.html { redirect_to edit_game_path(@game), notice: 'Level was successfully created.' }
          # format.json { render action: 'show', status: :created, location: @game }
          else
            @level.puzzle.build_picture
            format.html { render action: 'new' }
            format.json { render json: @level.errors, status: :unprocessable_entity }
          end
        end
      #end
    end
  end

  # PATCH/PUT /levels/1
  # PATCH/PUT /levels/1.json
  def update
    @game = Game.friendly.find(params[:game_id])
    impressionist(@game)
    ActiveRecord::Base.transaction do
      respond_to do |format|
        if @level.update_attributes(level_params)
           #@task =  @level.task
           #@task.source_type = params['task_source_type']
           #@task.save
          format.html { redirect_to edit_game_path(@game), notice: 'Level was successfully updated.' }
        # format.json { render action: 'show', status: :created, location: @game }
        else
          format.html { render action: 'edit' }
          format.json { render json: @level.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /levels/1
  # DELETE /levels/1.json
  def destroy
    impressionist(@game)
    @level.destroy
    respond_to do |format|
      format.html { redirect_to levels_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_level
    @level = Level.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def level_params
    params.fetch(:level).permit(:id,:name ,
                             puzzle_attributes: [:id, :name, :ptype, :hintbox, :winrules, :hinturl,
                                                 picture_attributes: [:id,:picture]],
                             task_attributes: [:id,:name ,:source_type ,:rule_type, :rule_operand, :goal_count, :promotion_title, :promotion_url])
  end

    def set_current_user
     @current_user = User.new(:id => current_business.id)
    end
end
