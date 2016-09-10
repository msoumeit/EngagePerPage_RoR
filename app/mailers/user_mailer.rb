class UserMailer < ActionMailer::Base
  default from: "mail@engageperpage.com" 
  def welcome_email(user)
    @user = user
    mail(:from => "play@engageperpage.com", :to => user.email, :subject => "Welcome to EngagePerPage.")
  end

  def reset_password_email(user)
    @user = user
    @password_reset_url = 'http://localhost:3000/password_reset?' + @user.password_reset_token
    mail(:to => user.email, :subject => 'Password Reset Instructions.')
  end
  
  def invite_request(email, reason)
    @email = email
    @reason = reason
    mail(:from => "invite@engageperpage.com",:to => "engageperpage@gmail.com",:subject => 'Invite Request.')
  end
  
  def feedback(name, email, feedback)
    @name = name
    @email = email
    @feedback = feedback
    mail(:from => "feedback@engageperpage.com",:to => "engageperpage@gmail.com",:subject => 'Feedback Recieved.')
  end
end
