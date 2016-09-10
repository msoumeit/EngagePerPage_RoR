class Users::RegistrationsController < Devise::RegistrationsController
  impressionist :actions => [:new]
  layout 'business_login'
 
  def create
    super
    impressionist(resource)      
  end
  
  def resource_name
    :user
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def after_sign_up_path_for(resource)
    session[:previous_url]
  end

  def permitted_params
    devise_parameter_sanitizer.for(:user) { |u| u.permit(:email, :password, :password_confirmation, :name) }
  end
  
  protected

    def after_update_path_for(resource)
      session[:previous_url]
    end
end 