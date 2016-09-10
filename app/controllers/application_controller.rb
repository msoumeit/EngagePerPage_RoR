class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_location
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  before_filter :configure_permitted_parameters, if: :devise_controller?

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
  end

  #called by last route matching unmatched routes.  Raises RoutingError which will be rescued from in the same way as other exceptions.
  def raise_not_found!
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  #render 500 error
  def render_error(e)
    respond_to do |f|
      f.html{ render :template => "errors/500", :status => 500 , :layout => false}
      f.js{ render :partial => "errors/ajax_500", :status => 500, :layout => false }
    end
  end

  #render 404 error
  def render_not_found(e)
    respond_to do |f|
      f.html{ render :template => "errors/404", :status => 404, :layout => false }
    end
  end

  # def authenticate_user
  #   if current_user.nil?
  #     flash[:error] = ' You must be signed in to view that page.'
  #     redirect_to :root
  #   end
  # end

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless (request.fullpath =~ /\/users/ || request.fullpath =~ /\/businesses/ )
  end

  def record_not_found
    respond_to do |f|
      f.html{ render :template => "errors/404", :status => 404, :layout => false }
    end
  end

  def configure_permitted_parameters
    if resource_class == User || resource_class == Business
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.for(:account_update) { |u|
        u.permit(:password, :password_confirmation, :current_password)
      }
      devise_parameter_sanitizer.for(:accept_invitation).concat [:name]
    end
  end
  private

  def after_sign_out_path_for(resource_or_scope)
    request.referer
  end

  protected

  def authenticate_inviter!
    if current_business.role?("admin")
      current_business
    end
  end

  def fb_liked?
    session[:signed_request]['page']['liked'] if session[:signed_request]
  end

  def fb_admin?
    session[:signed_request]['page']['admin'] if session[:signed_request]
  end

  def fb_page
    if session[:signed_request]
      session[:signed_request]['page']['id'] 
    end
  end
  
  helper_method :fb_liked?, :fb_admin? , :fb_page

  before_filter do
    if params[:signed_request]
      oauth = Koala::Facebook::OAuth.new(API_KEYS['facebook_business']['api_key'], API_KEYS['facebook_business']['api_secret'])
      session[:signed_request] = oauth.parse_signed_request(params[:signed_request])
    end
  end
  
  
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
  end

  def create_guest_user
    u = User.create(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end



end
