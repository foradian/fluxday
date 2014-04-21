class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  extend FriendlyId
  friendly_id :employee_code

  mount_uploader :image, ImageUploader
  has_many :project_managers
  has_many :projects, :through => :project_managers
  has_many :team_members
  has_many :teams, :through => :team_members
  has_many :admin_teams, :through => :projects, :source => :teams
  has_many :leads, -> { where role: 'lead' }, class_name: 'TeamMember'
  has_many :admin_teams, :through => :leads, :source => :team #,:foreign_key=>'user_id'
  has_many :joined_projects, :through => :teams, :source => :project
  #has_many :task_assignees
  #has_many :assignments, :through => :task_assignees, :source => :task
  has_many :comments
  has_many :reporting_managers
  has_many :work_logs
  has_many :okrs
  has_many :tasks #authored ones
  has_many :objectives, :through => :okrs
  has_many :key_results, :through => :objectives
  has_many :assignments,->{uniq}, :through => :key_results, :source => :tasks
  has_many :managers, :through => :reporting_managers, :class_name => 'User'
  has_many :reporting_employees, :class_name => "ReportingManager", :foreign_key => "manager_id"
  has_many :users, :through => :reporting_employees, :class_name => 'User', :foreign_key => "user_id"
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2,:fluxapp] #, :registerable
  scope :active, -> { where(is_deleted: false) }
  scope :by_name, -> { order("name ASC") }

  validates_presence_of :name, :nickname
  validate :email, :presence=>true,:uniqueness=>true
  validate :employee_code, :presence=>true,:uniqueness=>true

  #default_scope {where.not(is_deleted:true).order("name ASC")}
  #default_scope {order("name ASC")}

  def admin?
    role.downcase == 'admin'
  end

  def manager?
    role.downcase.in?(['manager', 'admin'])
  end

  def employee?
    role.downcase == 'employee'
  end

  def assigned_and_written_tasks
    Task.where(id:(task_ids + assignment_ids).uniq)
  end

  def watching_tasks
    Task.where("id IN (?) OR team_id IN (?)",(task_ids + assignment_ids).uniq,admin_team_ids)
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first
    #unless user
    #  user = User.create(name: data["name"],
    #                     email: data["email"],
    #                     password: Devise.friendly_token[0,20]
    #  )
    #end
    user
  end

end
