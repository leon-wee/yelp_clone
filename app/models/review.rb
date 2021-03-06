class Review < ActiveRecord::Base
  include AsUserAssociationExtension
  has_many :endorsements
  belongs_to :restaurant
  belongs_to :user
  validates :rating, inclusion: (1..5)
  validates :user, uniqueness: { scope: :restaurant, message: "has reviewed this restaurant already" }
end
