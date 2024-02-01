set :environment, 'development'
set :output, "log/cron_job.log"

env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']


every 1.day, at: '12:00 am' do
  runner "Admin::DailyNotificationsController.new.send_daily_activities_email"
end