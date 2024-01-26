class Lesson < ApplicationRecord
  belongs_to :course

  validates :name, presence: true
  validates :description, presence: true
  validates :course_id, presence: true
  validate :course_id_exists

  private
    def course_id_exists
      errors.add(:course_id, "must exist") unless Course.exists?(course_id)
    end
end
