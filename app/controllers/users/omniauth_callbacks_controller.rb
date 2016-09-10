class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = Social.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    game_id = request.env["omniauth.params"]["game"]
    if !@user.nil?
      #redirect_to show_game_stage_path(game_id)
      render 'stages/callback', :layout => false
    end
=begin 
   if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
=end
  end
  
   def google_oauth2
     
    @user = Social.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
 
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def twitter
    auth = env["omniauth.auth"]
    #Rails.logger.info("auth is **************** #{auth.to_yaml}")
    @user = Social.find_for_twitter_oauth(request.env["omniauth.auth"],current_user)
    game_id = request.env["omniauth.params"]["game"]
    if !@user.nil?
      #redirect_to show_game_stage_path(game_id)
       render 'stages/callback', :layout => false
    end
  end
  
  
    def facebook_business
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @business = Connect.find_for_facebook_oauth(request.env["omniauth.auth"], current_business)
    game_id = request.env["omniauth.params"]["game"]
    if !@business.nil?
      #redirect_to show_game_stage_path(game_id)
      render 'stages/callback', :layout => false
    end
  end
  
  
end