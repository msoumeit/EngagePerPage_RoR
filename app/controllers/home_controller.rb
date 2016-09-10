class HomeController < ApplicationController
  before_filter :authenticate_business!
  before_action :set_current_user
  impressionist
  def index
    if current_business.role?("admin")
      @number_of_games = Game.all.count
    else
      @number_of_games = current_business.games.count
    end

  end

  private

  def set_current_user
    @current_user = User.new(:id => current_business.id)
  end
end