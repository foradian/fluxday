class WorkLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates_presence_of :task_id
  # validates_inclusion_of :date, :in => 6.day.ago..Date.today,:message=>'Date should be older than 5 days'
  validates_inclusion_of :date, :in => Proc.new{ 6.day.ago..Date.today },:message=>'Date should be older than 5 days'
  #default_scope{ where.not(is_deleted: true) }

  scope :active, -> { where(is_deleted: false) }

  def self.user_logs_dated(user, date)
    user.work_logs.find_by_date(Date.today.to_date)
  end

  def hours
    return "#{self.minutes.to_i/60}:#{ '%02d' % (self.minutes.to_i%60)}"
  end
end
