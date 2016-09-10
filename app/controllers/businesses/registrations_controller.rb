class Businesses::RegistrationsController < Devise::RegistrationsController
  before_filter :check_guest
  impressionist :actions => [:new]
  layout 'business_login'
  
  def create
    super
    impressionist(resource)      
  end
  
  def resource_name
    :business
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:business]
  end

  def after_sign_up_path_for(resource)
    dashboard_path
  end

  def permitted_params
    params.permit(:business => [:email, :password, :password_confirmation, :name])
  end
  
  private
  
  def check_guest
  if(!current_business.blank?)
    if(current_business.role?("guest"))
        redirect_to :back, :notice => "Demo Account cannot be reset"
    end
  end
  end
end 