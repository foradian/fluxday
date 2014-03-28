class WorkLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  def self.user_logs_dated(user, date)
    user.work_logs.find_by_date(Date.today.to_date)
  end

  def hours
    return "#{self.minutes.to_i/60}:#{self.minutes.to_i%60}"
  end
end
