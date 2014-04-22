namespace :tracker do
  desc "Create general tasks"
  task :issue_general_tasks => :environment do
    logger = Logger.new('log/general_tasks.log')
    logger.info "---------------------------#{Date.today.strftime('%d-%m-%Y')}----------------------------"
    logger.info "-------------------------------------------------------------------------------------------"
    logger.info "|                                                                                         |"
    start_date = "2014-04-01".to_date.beginning_of_day
    end_date = "2015-03-31".to_date.end_of_day
    User.all.each do |user|
      okr = user.okrs.new(:name=>"General tasks",:start_date=>start_date,:end_date=>end_date,:approved=>true,:is_deleted=>false)
      okr.objectives.new(:name=>"General objective",:start_date=>start_date,:end_date=>end_date,:is_deleted=>false,:user_id=>user.id).key_results.new(:name=>"Miscellaneous",:start_date=>start_date,:end_date=>end_date,:is_deleted=>false,:user_id=>user.id)
      okr.save
      logger.info "|                   Created OKR for #{user.name} from #{start_date.strftime("%d %B %Y")} to #{end_date.strftime("%d %B %Y")}                         |"
    end
    logger.info "|                                                                                         |"
    logger.info "-------------------------------------------------------------------------------------------"
    logger.info ""
    logger.info "*******************************************************************************************"
    p 'Completed'
  end
end