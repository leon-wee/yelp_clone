class Restaurant < ActiveRecord::Base
  include AsUserAssociationExtension

  has_many :reviews, -> { extending WithUserAssociationExtension }, dependent: :destroy

  validates :name, length: { minimum: 3 }, uniqueness: true
  validates_presence_of :user
  belongs_to :user

  def average_rating
    reviews.none? ? 'N/A' : reviews.average(:rating)
  end

end
