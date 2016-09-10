class Users::SessionsController < Devise::SessionsController
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

  def after_sign_in_path_for(resource)
    session[:previous_url]
  end

end 