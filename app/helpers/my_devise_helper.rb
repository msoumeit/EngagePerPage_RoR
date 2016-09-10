module MyDeviseHelper
  def devise_error_messages1!
    resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
  end

  def devise_error_messages2!
    resource.errors.full_messages.map { |msg| content_tag(:p, msg) }.join.html_safe
  end
end