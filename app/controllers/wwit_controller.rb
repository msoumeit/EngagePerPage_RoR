class WwitController < ApplicationController
  impressionist
  layout 'wwit'
  
  def works
    
  end
  def invite_req
    render :invite , :layout => "business_login"
  end

  def invite_sent
    email = params[:email]
    reason = params[:reason]
    UserMailer.invite_request(email, reason).deliver
    respond_to do |format|
      flash[:notice] = 'Invite request has been sent successfully.You will receive an email with the signup details shortly.'
      format.html { render "invite", :layout => "business_login"}
    end
  end

  def invite_main
    email = params[:email]
    reason = "Main Page"
    UserMailer.invite_request(email, reason).deliver
    render :text =>'Invite request has been sent successfully.You will receive an email with the signup details shortly.'

  end

  def feedback_req
    render :feedback , :layout => "business_login"
  end

  def feedback
    name = params[:name]
    email = params[:email]
    feedback = params[:feedback]
    UserMailer.feedback(name,email, feedback).deliver
    respond_to do |format|
      flash[:notice] = 'Thank you for the your feedback.'
      format.html { render "feedback", :layout => "business_login"}
    end
  end

  def demo_business

    @business = Business.find_by_email("demo.engageperpage@gmail.com")
    sign_in @business
    redirect_to dashboard_path , :notice => "Welcome to the EngagePerPage Demo account.This is a restricted version and certain feaures are only available in the full version"
    return

  end
end