class Businesses::PasswordsController < Devise::PasswordsController
  before_filter :check_guest
  layout 'business_login'
  
  
def check_guest
  if(!params[:business].blank?)
    business = Business.find_by_email(params[:business][:email])
    if(business.role?("guest"))
        redirect_to :back, :notice => "Demo Account cannot be reset"
    end
  end
  end
end