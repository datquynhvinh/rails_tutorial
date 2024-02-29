class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course

  private
    def send_reset_password_instructions_job(token)
      ResetPasswordEmailJob.perform_later(self, token)
    end
end
