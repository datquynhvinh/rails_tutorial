class Course < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :user_courses, dependent: :destroy

  private
    def self.ransackable_attributes(*)
      %w[name]
    end
end
