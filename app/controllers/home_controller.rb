class HomeController < ApplicationController
  def index
    if current_user.present?
      dashboard
      render 'home/dashboard'
    else

    end
  end

  def dashboard
    date = params[:date].present? ? parama[:date].to_date : Date.today
    @start_date = date.beginning_of_week
    @end_date = date.end_of_week
    @entries={}
    entries = Task.where('start_date <= ? && end_date >= ?',@end_date.end_of_day,@start_date.beginning_of_day)
    (@start_date..@end_date).each do |dt|
      @entries[dt] = entries.where('start_date <= ? && end_date >= ?',dt.end_of_day,dt.beginning_of_day)
    end
  end
end
