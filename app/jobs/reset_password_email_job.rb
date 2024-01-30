class ResetPasswordEmailJob < ApplicationJob
  queue_as :default

  self.set(wait: 1.minute)

  def perform(user, token)
    DeviseMailer.reset_password_instructions(user, token).deliver_now
  end
end
