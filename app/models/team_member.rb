class TeamMember < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  after_save :update_member_counts

  def update_member_counts
    team.update_attributes(:members_count=>team.users.active.count,:managers_count=>team.team_leads.active.count)
    team.project.update_attributes(:member_count=>team.project.project_members.active.count)
  end
end
