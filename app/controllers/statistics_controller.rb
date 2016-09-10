class StatisticsController < ApplicationController
  def game_power(timeago=1.week.ago)

    imp_ids = current_business.games.pluck(:id)
    ps = Impression.all(
    :select => 'created_at::date , count(*) count',
    :group => 'created_at::date',
    :conditions => ["action_name = 'show_game' AND impressionable_id IN (?) AND created_at > ?", imp_ids , timeago],
    :order => "created_at::date asc"
    )

    stat_str = ps.collect{ |u| [((u.created_at).to_time.utc.to_i) * 1000 ,u.count]}
    #stat_str = ps.inject([]) do |result, p|
    # 1.weeks.ago.to_date..Date.today).map { |date| Order.download.total_on(date).to_f}
    render :json => stat_str.to_json
  end

  def magnetic_power(timeago=1.week.ago)
    
    ps = Impression.all(
    :select => 'created_at::date , count(*) count',
    :group => 'created_at::date',
    :conditions => ["impressionable_type IN ('Wwit' , 'User' , 'Registration', 'Home') AND created_at > ?", timeago],
    :order => "created_at::date asc"
    )

    stat_str = ps.collect{ |u| [((u.created_at).to_time.utc.to_i) * 1000 ,u.count]}
   
     render :json => stat_str.to_json
  end
end
