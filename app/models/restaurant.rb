class Restaurant < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  validates :name, length: { minimum: 3 }, uniqueness: true
  belongs_to :user

  def build_review(params, user)
    self.reviews.new(thoughts: params[:thoughts], rating: params[:rating], user_id: user.id)

  end
end
