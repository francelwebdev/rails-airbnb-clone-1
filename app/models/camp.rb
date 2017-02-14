class Camp < ApplicationRecord
  # associations
  belongs_to :user
  has_many :bookings
  # validations
  validates :title, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :price, presence: true

  mount_uploader :photo, PhotoUploader
end
