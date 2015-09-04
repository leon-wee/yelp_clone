class Restaurant < ActiveRecord::Base
  has_many :reviews, -> { extending WithUserAssociationExtension }, dependent: :destroy

  validates :name, length: { minimum: 3 }, uniqueness: true
  validates_presence_of :user
  belongs_to :user

  # def build_review(params, user)
  #   self.reviews.new(thoughts: params[:thoughts], rating: params[:rating], user_id: user.id)
  # end
end
