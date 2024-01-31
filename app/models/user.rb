class User < ApplicationRecord
  acts_as_paranoid column: :deleted_at
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :user_courses, dependent: :destroy
  has_many :user_section_statuses, dependent: :destroy
  has_many :activities, dependent: :destroy

  has_one_attached :avatar
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png], message: "must be a valid image format" }, size: { less_than: 5.megabytes, message: "should be less than 5MB" }

  before_save :downcase_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  validates :name, presence: true, length: { maximum: 50 }

  def feed
    Micropost
  end

  def follow(other_user)
    following << other_user
    create_activity("#{self.name} Followed #{other_user.name}")
  end

  def unfollow(other_user)
    following.delete(other_user)
    create_activity("#{self.name} Unfollowed #{other_user.name}")
  end

  def create_activity(activity_description)
    activities.create(activity: activity_description)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
    end
  end

  def send_reset_password_instructions
    token = set_reset_password_token
    send_reset_password_instructions_job(token)
  end

  private
    def downcase_email
      self.email = email.downcase
    end

    def self.ransackable_attributes(*)
      %w[name]
    end

    def send_reset_password_instructions_job(token)
      ResetPasswordEmailJob.perform_later(self, token)
    end
end
