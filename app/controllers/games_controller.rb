class GamesController < ApplicationController
  before_filter :authenticate_business!
  before_action :set_game, only: [:show, :edit, :update, :wall_of_fame, :set_reviewed, :demo, :generate_leads]
  before_action :set_current_user
  before_action :is_admin, only:[:set_reviewed]
  impressionist :actions => [:new]
  # GET /games
  # GET /games.json
  def index
    if is_admin
      @games = Game.all.order('created_at DESC')
    else
      @games = current_business.games.order('created_at DESC')
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
    @levels = @game.levels.order('position ASC')
    @incentives = @game.prizes.order('created_at DESC')
    @connect = current_business.connects.where(:provider => "facebook_business").first
    if !@connect.nil?
      @graph = Koala::Facebook::API.new(@connect.token)
      @pages = @graph.get_connections('me', 'accounts')
    end
  end

  # GET /games/1/edit
  def edit
    @levels = @game.levels.order('position ASC')
    @owner_id = @game.id
    @ownertype = "prizes"
    @incentives = @game.prizes.order('created_at DESC')
    @connect = current_business.connects.where(:provider => "facebook_business").first
    if !@connect.nil?
      @graph = Koala::Facebook::API.new(@connect.token)
      @pages = @graph.get_connections('me', 'accounts')
    end
    impressionist(@game)
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    @game.business_name = current_business.name
    @connect = current_business.connects.where(:provider => "facebook_business").first

    if !@connect.nil?
      @graph = Koala::Facebook::API.new(@connect.token)
      @pages = @graph.get_connections('me', 'accounts')

      page = @pages.select{|key| key["id"] == params[:page] }.first
      @game.page_id = page["id"]
      @game.page_name = page["name"]
      @game.page_access_token = page["access_token"]

    end

    respond_to do |format|
      if @game.save
        current_business.games << @game
        impressionist(@game)
        homepage = game_params[:homepage]
        savepath =  Rails.root.join('public','games', @game.id.to_s + '.png')
        UserMailer.feedback(current_business.name,current_business.email, "New Game created. Please authorize").deliver
        #ScreenShot.capture homepage,  savepath
        #File.delete(savepath)

        format.html { redirect_to edit_game_path(@game), notice: 'Game was successfully created. The Game will be available after it is reviewed for allowed content.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      @game.business_name = current_business.name
      @connect = current_business.connects.where(:provider => "facebook_business").first

      if !@connect.nil?
        @graph = Koala::Facebook::API.new(@connect.token)
        @pages = @graph.get_connections('me', 'accounts')

        page = @pages.select{|key| key["id"] == params[:page] }.first
        if (@game.page_id != page["id"])
        @game.page_id = page["id"]
        @game.page_name = page["name"]
        @game.page_access_token = page["access_token"]
        @game.is_reviewed = 0
        @game.save
        end
        
      end

      if @game.update(game_params)
        homepage = game_params[:homepage]
        @page = Koala::Facebook::API.new(@game.page_access_token)
        @page.put_object("me", "tabs/app_" + API_KEYS['facebook_business']['api_key'], {:position =>2, :custom_name => @game.name , :custom_image_url => @game.logo.url(:flogo)})

        impressionist(@game)
        #savepath = Rails.public_path.to_s + "/games/" + @game.id.to_s + ".png"
        savepath =  Rails.root.join('public','games', @game.id.to_s + '.png')
        puts savepath
        UserMailer.feedback(current_business.name,current_business.email, "Game updated. Please authorize").deliver
        #ScreenShot.capture homepage,  savepath
        format.html { redirect_to edit_game_path(@game), notice: 'Game was successfully updated.The Game will be available after it is reviewed for allowed content.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def wall_of_fame
    player_ids = @game.milestones.pluck(:player_id)
    @players = Player.find(player_ids)
    render :walloffame , :layout => "business_login"
    impressionist(@game)
  end

  def set_reviewed
    @game.is_reviewed = 1
    @game.save

    #Add App to Page
    @page = Koala::Facebook::API.new(@game.page_access_token)
    @page.put_object("me","tabs",:app_id =>API_KEYS['facebook_business']['api_key'])
    @page.put_object("me", "tabs/app_" + API_KEYS['facebook_business']['api_key'], {:position =>2, :custom_name => @game.name , :custom_image_url => @game.logo.url(:flogo)})

    respond_to do |format|
      format.html { redirect_to(:action => 'index') }
    end
  end

  def generate_leads
    
     respond_to do |format|
     UserMailer.feedback(current_business.name,current_business.email, "Generate and Send Leads To Business").deliver
     
     format.html { redirect_to games_path, notice: 'Request submitted successfully. You will receive the leads within a day.' }
     format.json { head :no_content }
     end
      
  end
  
  
  def demo

    if(!current_business.blank?)
      if(current_business.role?("guest"))
        redirect_to :back, :notice => "Game preview not available in the demo."
      return
      end
    end

    render 'demo'

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.friendly.find(params[:id])

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_params
    params.require(:game).permit(:name,:logo, :business_name, :is_reviewed)
  end

  def set_current_user
    @current_user = User.new(:id => current_business.id)
  end

  def is_admin
    current_business.role?("admin")
  end
end
