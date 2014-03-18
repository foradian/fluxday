class CalendarController < ApplicationController
  def index
  end

  def weekly
    unless params[:date].present?
      @start_date = Date.today.beginning_of_week
      @end_date = Date.today.end_of_week
    else
      date = params[:date].to_date
      @start_date = date.beginning_of_week
      @end_date = date.end_of_week
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
