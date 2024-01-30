class Lesson < ApplicationRecord
  belongs_to :course
  has_many :sections, dependent: :destroy
  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :description, presence: true
  validates :course_id, presence: true
  validate :course_id_exists

  private
    def course_id_exists
      errors.add(:course_id, "must exist") unless Course.exists?(course_id)
    end

    def self.ransackable_attributes(*)
      %w[name]
    end
end
