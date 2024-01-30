class Section < ApplicationRecord
  belongs_to :lesson
  has_many :user_section_statuses

  validates :name, presence: true
  validates :question, presence: true
  validates :answer, presence: true

  private
    def send_reset_password_instructions_job(token)
      ResetPasswordEmailJob.perform_later(self, token)
    end
end
