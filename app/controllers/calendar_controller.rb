class CalendarController < ApplicationController
  def index
  end

  def day
    unless params[:date].present?
      @date = Date.today
    else
      @date = params[:date].to_date
    end
    @entries = current_user.assigned_and_written_tasks.where('start_date <= ? && end_date >= ?',@date.end_of_day,@date.beginning_of_day)
    @work_logs = current_user.work_logs.find_all_by_date(@date)
  end

  def week
    unless params[:date].present?
      @start_date = Date.today - 6.days#.beginning_of_week
      @end_date = @start_date+6.days#.end_of_week
    else
      date = params[:date].to_date
      @start_date = date#.beginning_of_week
      @end_date = date+6.days#.end_of_week
    end
    @entry_hash={}
    entries = current_user.work_logs.where('date <= ? && date >= ?', @end_date.end_of_day, @start_date.beginning_of_day)
    (@start_date..@end_date).each do |dt|
      @entry_hash[dt] = entries.where('date <= ? && date >= ?', dt.end_of_day, dt.beginning_of_day)
    end


  end

  def monthly
    unless params[:date].present?
      @start_date = Date.today.beginning_of_month
      @end_date = Date.today.end_of_month
    else
      date = params[:date].to_date
      @start_date = date.beginning_of_month
      @end_date = date.end_of_month
    end
    @prev_month = @start_date.beginning_of_week..(@start_date-1)
    @next_month = (@end_date+1)..@end_date.end_of_week
  end
end
