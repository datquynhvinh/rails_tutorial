class Influencer < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
