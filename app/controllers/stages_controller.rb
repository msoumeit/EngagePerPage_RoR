class StagesController < ApplicationController
  #before_filter :authenticate_user! , :except => [:show_game,:start_game, :get_level_task]
  skip_before_filter :verify_authenticity_token , :only => [:show_game, :start_game]
  before_action :set_game, only: [:show_game, :assist, :wallet]
  after_action :allow_iframe, only: :show_game

  layout 'stagev2'
  def start_game
    page_id = fb_page
    @game = Game.find_by_page_id(page_id)
    
    if @game.nil?
      @game = Game.find_by_id(1)    
    end
    
    if @game.nil?
      render :template => "games/game_status" ,:content_type => 'text/html'
    return
    end
    
    if fb_liked?
      params[:id] = @game.slug
      respond_to do |format|
        format.html { redirect_to(:action => 'show_game', :id => @game.id) }
        format.js   {  render :nothing => true }
      end
    else
      render 'firstact_new', :content_type => 'text/html'
    end

  end

  def show_game
    impressionist(@game)
    if current_or_guest_user.nil?
      redirect_to new_user_session_path
    return
    end
    @totallevels = @game.levels.count
    if @totallevels == 0 || @game.is_reviewed.zero?
      render :template => "games/game_status" ,:content_type => 'text/html'
    return
    end

    @player = current_or_guest_user.player
    @milestone = @player.milestones.select("*").joins(:level).where(:levels => {:game_id => @game.id}).order("milestones.id DESC").first

    #First Level
    if ( @milestone.nil?)
      @level = @game.levels.first;
    #Level Partial Complete Puzzle Completed Task Pending
    elsif (@milestone.isPuzzleComplete && !@milestone.isTaskComplete)
      level_id = @milestone.level_id
      @level = Level.find_by_id(level_id);
      if (!@milestone.art_id.blank?)
        #@post = @graph.get_object(@milestone.art_id)
        @social = current_user.socials.where(:provider => @level.task.source_type.downcase).first
        @post = StagesController.get_Art(@milestone.art_id , @level.task, @social)
        if (!@post['likes'].nil?)
          @number_of_likes = @post['likes']['data'].count
        else
          @number_of_likes = @post['favorite_count']
        end
      end
    else
    #Level Complete
      level_id = @milestone.level_id
      @prevlevel = Level.find_by_id(level_id);
      @level= @prevlevel.lower_item

      #Level Reward Player
      if (!@level.nil?)
        lincentive = @prevlevel.rewards.where(:player_id => nil).first
        if( !lincentive.nil?)
        @player.incentives << lincentive
        end
      end
      @milestone = Milestone.new
    end

    #Game Complete
    #Game Prize Player
    @player_ids = @game.milestones.pluck(:player_id)
    @players = Player.find(@player_ids)

    if @level.nil?
      gincentive = @game.prizes.where(:player_id => nil).first
      if( !gincentive.nil?)
      @player.incentives << gincentive
      end
      #Level Reward Player
      lincentive = @prevlevel.rewards.where(:player_id => nil).first
      if( !lincentive.nil?)
      @player.incentives << lincentive
      end
      render :final_stage_new
    return
    end

    @task = @level.task
    @social = current_or_guest_user.socials.where(:provider => @level.task.source_type.downcase).first

    if (!@milestone.nil? && @milestone.isPuzzleComplete && !@milestone.isTaskComplete)
      render :taskstage , :layout => "stage"
    return
    end

    render 'index'
  end

  def check_answer
    @player = current_or_guest_user.player
    @level = Level.find(params[:id])
    @puzzle = @level.puzzle
    answers = @puzzle.winrules.split(",")
    answers.each do |ans|
      if (ans.upcase == params[:answerinput].upcase)
        @milestone = @player.milestones.where(:level_id => @level.id).first
        if ( @milestone.nil?)
          @milestone = Milestone.new(:level_id => @level.id, :player_id => @player.id , :game_id => @level.game.id, :isPuzzleComplete => true , :isTaskComplete => true)
        end
        @milestone.save
        params[:id] = @level.game.id
        respond_to do |format|
          format.html { redirect_to(:action => 'show_game') }
          format.js   {  render :nothing => true }
        end
      return
      end

    end

    render :partial => 'incorrectanswer', :content_type => 'text/html'
  end

  def facebook_post
    @player = current_user.player
    @social = current_user.socials.where(:provider => "facebook").first
    @graph = Koala::Facebook::API.new(@social.token)
    @level = Level.find(params[:levelid])
    @task = @level.task
    @milestone = @player.milestones.where(:level_id => params[:levelid]).first
    if(params[:operation].blank?)
      if(!@milestone.art_id.blank?)
        @post = @graph.get_object(@milestone.art_id)
      end
    else
    #profile = @graph.get_object("me")
    #friends = @graph.get_connections("me", "friends")
    #@graph.put_connections("me", "feed", :message => "I am writing on my wall!")
      id = @graph.put_wall_post(params[:fbpost], {:name => @task.promotion_title, :link => @task.promotion_url})
      @post = @graph.get_object(id['id'])
      @milestone.art_id = id['id']
      puts id['id']
    @level.task = @task
    @milestone.save
    end
    if (!@post['likes'].nil?)
      @number_of_likes = @post['likes']['data'].count

      if(@task.rule_operand == "equals" && (@number_of_likes == @task.goal_count || @number_of_likes > @task.goal_count ))
        @milestone.isTaskComplete = true
        @milestone.save
        respond_to do |format|
          format.html { redirect_to(:action => 'show_game') }
          format.js   {  render :nothing => true }
        end
      return
      end
    end
    respond_to do |format|
      format.html { render :partial => 'facebook_post', :content_type => 'text/html'}
    end
  end

  def twitter_post
    @player = current_user.player
    @social = current_user.socials.where(:provider => "twitter").first
    @level = Level.find(params[:levelid])
    @task = @level.task
    twitter = TwitterClient.new(@social)
    @milestone = @player.milestones.where(:level_id => params[:levelid]).first
    if(params[:operation].blank?)
      @post = twitter.get_tweet(@milestone.art_id)
    else
    #profile = @graph.get_object("me")
    #friends = @graph.get_connections("me", "friends")
    #@graph.put_connections("me", "feed", :message => "I am writing on my wall!")
      id = twitter.tweet(params[:twpost].to_s() + " " + @task.promotion_title)
      @post = twitter.get_tweet(id['id'])
      @milestone.art_id = id['id']
      puts id['id']
    @level.task = @task
    @milestone.save
    end
    if (!@post.nil?)
      @number_of_likes = @post['favorite_count']

      if(@task.rule_operand == "equals" && (@number_of_likes == @task.goal_count || @number_of_likes > @task.goal_count ))
        @milestone.isTaskComplete = true
        @milestone.save
        respond_to do |format|
          format.html { redirect_to(:action => 'show_game') }
          format.js   {  render :nothing => true }
        end
      return
      end
    end
    respond_to do |format|
      format.html { render :partial => 'twitter_post', :content_type => 'text/html'}
    end
  end

  def get_level_task
    if (params[:id].nil?)
      @task = Task.new
    else
      level = Level.find(params[:id])
      @task = level.task
      if @task.blank?
        @task = Task.new
      end
    end
    @sourceType = params[:tasktype]
    respond_to do |format|
      if( @sourceType == "Facebook")
        format.html { render :partial => 'facebook_post_task', :content_type => 'text/html'}
      elsif (@sourceType == "Twitter")
        format.html { render :partial => 'twitter_post_task', :content_type => 'text/html'}
      else
      end

    end
  end

  def self.get_Art(art_id, task, social)
    if (task.source_type == "Facebook" )
      @graph = Koala::Facebook::API.new(social.token)
    return @graph.get_object(art_id)
    else
      twitter = TwitterClient.new(social)
    return twitter.get_tweet(art_id)
    end
  end

  def assist
    respond_to do |format|
      format.html { render 'assist', :content_type => 'text/html'}
    end
  end

  def wallet
    @player = current_user.player
    respond_to do |format|
      format.html { render 'wallet', :content_type => 'text/html', :layout => 'stage'}
    end
  end

  def fb_logout
    # impressionist(@game)
    @social = current_user.socials.where(:provider => "facebook").first
    @social.destroy
    respond_to do |format|
      format.html { redirect_to(:action => 'show_game') }
      format.js   {  render :nothing => true }
    end
  end

  def tw_logout
    # impressionist(@game)
    @social = current_user.socials.where(:provider => "twitter").first
    @social.destroy
    respond_to do |format|
      format.html { redirect_to(:action => 'show_game') }
      format.js   {  render :nothing => true }
    end
  end

  def update_user
      name = params[:uname]
      email = params[:uemail]
      
      @user =  current_or_guest_user
      @player = current_or_guest_user.player
      
      @player.name = name
      @user.email = email
      @user.name = name
      
      @user.save
      @player.save
      
      sign_in @user
      redirect_to(:action => 'show_game')
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.friendly.find(params[:id])
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end