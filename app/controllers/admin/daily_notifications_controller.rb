class Admin::DailyNotificationsController < ApplicationController
  def send_daily_activities_email
    puts "Job start!"
    today = DateTime.now.strftime('%y-%m-%d')
    unique_user_ids = Activity.where("DATE_FORMAT(created_at, '%y-%m-%d') = ?", today)
                              .distinct.pluck(:user_id)
    unique_user_ids.each do |user_id|
      @user = User.find_by(id: user_id)
      activities = Activity.joins(:user).where("DATE_FORMAT(activities.created_at, '%y-%m-%d') = ?", today).where('users.id = user_id').to_a
      result_text = activities.map { |activity| "#{activity.created_at}: #{activity.activity}" }.join("\n")
      puts @user.name + ' ' + @user.email
      puts result_text
      UserDailyNotificationMailer.send_activity_notification(@user, result_text).deliver_later
    end

    puts "Job end!"
  end
end
