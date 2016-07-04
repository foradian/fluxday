namespace :tracker do
  desc "Update counts"
  task :update_counts => :environment do
    logger = Logger.new('log/count_update.log')
    logger.info "------------------------------- #{Date.today.strftime('%d-%m-%Y')} --------------------------------"
    logger.info "--------------------------- Processing user    ----------------------------"
    User.all.each do |user|
      user.admin_teams_count = user.admin_teams.count
      user.admin_projects_count = user.projects.count
      user.save
    end
    logger.info "--------------------------- Processing project ----------------------------"
    Project.all.each do |project|
      project.team_count = project.teams.active.count
      project.member_count = project.project_members.active.count
      project.save
    end
    logger.info "--------------------------- Processing team    ----------------------------"
    Team.all.each do |team|
      team.members_count = team.users.active.count
      team.managers_count = team.team_leads.active.count
      team.save
    end
    logger.info "***************************************************************************"
  end
end
