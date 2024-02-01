class UserDailyNotificationMailer < ApplicationMailer
  def send_activity_notification(user, activities_text)
    @user = user
    @activities_text = activities_text

    mail(to: @user.email, subject: 'Notification: Your Daily Activities')
  end
end
