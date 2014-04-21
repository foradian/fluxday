class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    alias_action :new, :edit, :create, :read, :update, :destroy, :to => :crud
    alias_action :new, :edit, :create, :read, :update, :to => :cru

    if user.admin?
      can :manage, :all
    elsif user.manager?
      can :manage, :all
      can :manage, :oauth_applications
    elsif user.employee?
      can [:edit,:update], Project, :id => user.project_ids
      can [:edit,:update], Team, :id => user.project_ids
      can :index, Team
      can :manage, Team, :project => {:id=>user.project_ids}
      can [:edit,:update], User, :id=>[user.id]+user.user_ids

      can :read, Project
      can :read, Team

      can :destroy, Okr do |okr|
        user.user_ids.include?(okr.user_id)
      end

      can :cru, Okr , :user => { :id => ([user.id] + user.user_ids)   }, :approved=>false
      #user.id || user.reporting_employee_ids.include?(okr.user_id)

      can :change_password, User
      can :read, Okr do |okr|
        okr.user_id == user.id || user.user_ids.include?(okr.user_id)
      end
      can :read, User
      can :manage, Task do |task|
        task.id.nil? || task.user_id == user.id || user.project_ids.include?(task.project_id) || user.admin_team_ids.include?(task.team_id)
      end

      can :read, Task do |task|
        task.id.nil? || task.user_id == user.id || task.user_ids.include?(user.id) || user.project_ids.include?(task.project_id) || user.team_ids.include?(task.team_id)
      end

      #can :read, :all
    else
      #can :read, :all
    end

    #if user.role.downcase == 'admin'
    #  can :manage, [Project, Team, User, Comment, WorkLog, Task]
    #elsif user.role.downcase == 'manager'
    #  can :manage, [Project, Team, User, Comment, WorkLog, Task]
    #elsif user.role.downcase == 'employee'
    #  can :read => [:project]
    #  can :manage => [:team]
    #  can [:new, :edit, :create, :read, :update, :destroy], [Project, Team, User, Comment, WorkLog, Task]
    #else
    #end

    #can :crud, User do |u|
    #  user.role.downcase == 'employee' #&& u.id == user.id
    #end

    #def manager
    #  can :manage, User
    #  can :manage, Project
    #  can :manage, Team
    #  can :manage, Task
    #  can :manage, WorkLog
    #end
    #
    #def admin
    #  manager
    #end
    #
    #def employee
    #  can :crud, User
    #end

    #can :read, Team, Team do |team|
    #  taem.published_at <= Time.now
    #end

    #can :read, Article, Article.published do |article|
    #  article.published_at <= Time.now
    #end


    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
