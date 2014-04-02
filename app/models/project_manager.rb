class ProjectManager < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  default_scope {where.not(status:'archived')}
  #default_scope order("name ASC")
end
