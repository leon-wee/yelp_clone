require 'rails_helper'

describe Review, type: :model do
  it { is_expected.to belong_to :restaurant }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:endorsements) }

  it 'is invalid if the rating is more than 5' do
    review = Review.new(rating: 10)
    expect(review).to have(1).error_on(:rating)
  end

  describe 'Reviews' do
    describe 'destroy_as_user' do
      let(:user) { create(:user, email: 'test@test123.com') }
      let(:user2) { create(:user, email: 'try@try.com') }
      let(:restaurant) { create(:restaurant) }
      let(:review) { create(:review, restaurant: restaurant, user: user) }

      context 'deleting a review' do
        it 'can be deleted by the creator' do
          review.destroy_as_user(user)
          expect(Review.first).to be nil
        end

        it 'cannot be deleted by non-creator' do
          review.destroy_as_user(user2)
          expect(Review.first.thoughts).to eq('so so')
        end
      end

    end
  end

end
