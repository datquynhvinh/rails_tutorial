class Course < ApplicationRecord
  has_many :lessions, dependent: :destroy
end
