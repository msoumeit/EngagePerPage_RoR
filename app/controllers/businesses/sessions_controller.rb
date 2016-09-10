class Businesses::SessionsController < Devise::SessionsController
  impressionist :actions => [:new]
  layout 'business_login'
  def create
    super
    impressionist(resource)
  end

  def update
    super
  end

  def resource_name
    :business
  end

  def after_sign_out_path_for(resource_or_scope)
    dashboard_path
  end

  def after_sign_in_path_for(resource_or_scope)
    dashboard_path
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:business]
  end

end 