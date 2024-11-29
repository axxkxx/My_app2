class User < ApplicationRecord
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable
  
    has_many :posts, dependent: :destroy
    has_many :comments
  # ผู้ติดตาม
  has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower
  
  # ผู้ที่ติดตาม
  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :followed
  
  def profile_picture_url
    profile_picture.presence || 'Default_pfp.jpg'
  end
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  end
  