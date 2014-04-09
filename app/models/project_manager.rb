class ProjectManager < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  default_scope {where.not(status:'archived')}
  #default_scope order("name ASC")

  after_save  :update_numbers
  after_destroy  :update_numbers

  def update_numbers
    user.update_attributes(:admin_projects_count=>user.projects.count)
    #update_attributes(:team_count=>self.teams.count)
  end
end
