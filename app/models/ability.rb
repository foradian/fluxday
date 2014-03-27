class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    alias_action :new, :edit, :create, :read, :update, :destroy, :to => :crud

    if user.admin?
      can :manage, :all
    elsif user.manager?
      can :manage, :all
    elsif user.employee?
      can [:edit,:update], Project, :id => user.project_ids
      can [:edit,:update], Team, :id => user.project_ids
      can :index, Team
      can :manage, Team, :project => {:id=>user.project_ids}
      can [:edit,:update], User, :id=>[user.id]+user.user_ids
      can :read, :all
    else
      can :read, :all
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
