class WidgetsController < ApplicationController
  def index
    respond_to do |format|
    # shows the widget generator form for the client
    #format.html
    # deliver the bootstrapping Javascript
    @game = Game.friendly.find(params[:gameshow])
    @gameshow = show_game_stage_url(@game)
      format.js { render "widgets", formats: [:js] }
      # deliver the rendered events as JSONP response to the widget
      format.json {
        @game = Game.friendly.find(params[:gameshow])
        render json: widget_url(show_game_stage_url(@game)) , callback: params[:callback]
      }
    end
  end

  private

  def widget_url(gameurl)
    t = {}
    t['eppwidget'] = {}
    t['eppwidget']['url'] = "<iframe src=\"" + gameurl + "\" scrolling=\'no\' frameborder=\'0\' width='380px' onload=\"resizeIframe(this)\"></iframe>"
    return t
  end
end