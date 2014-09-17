class Task < ActiveRecord::Base

  extend FriendlyId
  friendly_id :tracker_id

  belongs_to :user
  belongs_to :team
  belongs_to :project
  #has_many :task_assignees
  #has_many :users, :through => :task_assignees
  has_many :comments, :as => :source
  has_many :work_logs
  has_many :task_key_results
  has_many :key_results, :through => :task_key_results
  has_many :users, -> { uniq }, :through => :key_results


  default_scope { where.not(is_deleted: true).order('id desc') }

  before_create :add_tracker_id

  after_save :update_team_task_count
  before_update :update_completion

  belongs_to :root_task, :class_name => "Task", :foreign_key => "task_id"
  has_many :sub_tasks, :class_name => "Task", :foreign_key => "task_id"

  scope :active, -> { where(is_deleted: false) }
  scope :root, -> { where(task_id: nil) }
  scope :sub, -> { where("task_id IS NOT NULL") }
  scope :pending, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
  scope :searchable_for_user, lambda { |user| where("id in (?) OR id in (?) OR project_id in (?)  OR team_id in (?)", user.task_ids, user.assignment_ids, user.project_ids, user.team_ids) }
  #scope :, lambda { |user| where("id in (?) OR id in (?) OR project_id in (?)  OR team_id in (?)", user.task_ids, user.assignment_ids ,user.project_ids, user.admin_team_ids)}


  def updatable_by_user(user)
    return true if user_ids.include?(user.id)
    return true if user.admin_team_ids.include?(team_id)
    return true if user.project_ids.include?(project_id)
  end

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


  def update_team_task_count
    team.update_attributes(:pending_tasks => team.tasks.active.pending.count)
  end

  def add_tracker_id
    self.tracker_id = Task.unscoped.last.try(:tracker_id).to_i + 1
  end

  def timestamp
    created_at.strftime('%d %B %Y %H:%M:%S')
  end


  def update_completion
    if self.status? && self.status_changed? && self.status_change[1] == 'completed' and self.status_change[0] == 'active'
      self.completed_on = Time.now
    elsif self.status? && self.status_changed? && self.status_change[1] == 'active' and self.status_change[0] == 'completed'
      self.completed_on = nil
    end
  end

end
