class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :project
  has_many :task_assignees
  has_many :users, :through => :task_assignees
  has_many :comments, :as => :source

  belongs_to :root_task, :class_name => "Task", :foreign_key => "task_id"
  has_many :sub_tasks, :class_name => "Task", :foreign_key => "task_id"

  scope :active, -> { where(is_deleted: false) }


  def time_to_end
    if end_date.to_date == Date.today
      'Due today'
    elsif end_date <= Date.today
      'Ended on '+end_date.strftime('%d %B %Y')
    elsif end_date <= 7.day.from_now
      rem = (end_date.to_date - Date.today.to_date).to_i
      "#{rem} #{'day'.pluralize(rem)} left"
    else
      'Due '+end_date.strftime('%d %B %Y')
    end
  end
end
