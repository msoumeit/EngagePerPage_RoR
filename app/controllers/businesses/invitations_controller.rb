class Businesses::InvitationsController < Devise::InvitationsController
  skip_before_filter :require_no_authentication, :only => [:edit, :update, :destroy]
  layout 'business_login' , :only => [:edit , :update]
  def new
    if is_admin
    super
    else
      redirect_to dashboard_path
    end
  end

  def edit
    if !current_business.nil?
      sign_out(current_business)
    end
    super
  end
  
  def update
    super
     UserMailer.welcome_email(current_business).deliver  
  end

  def after_invite_path_for(resource_name)
    dashboard_path
  end
  
  def after_accept_path_for(resource)
    dashboard_path
  end
  
  private

  def is_admin
    current_business.role?("admin")
  end
end