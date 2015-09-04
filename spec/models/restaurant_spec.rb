require 'spec_helper'

describe Restaurant, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to have_many(:reviews).dependent(:destroy) }
  it { is_expected.to belong_to(:user) }

  it 'is not valid with a name of less than three characters' do
    restaurant = user.restaurants.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    user.restaurants.create(name: "Moe's Tavern")
    restaurant = user.restaurants.new(name: "Moe's Tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

  it 'is not valid if it has no creator' do
    restaurant = Restaurant.create(name: 'test', rating: 1)
    expect(restaurant).not_to be_valid
  end

  it 'is valid when it has a creator' do
    restaurant = user.restaurants.create(name: 'test', rating: 1)
    expect(restaurant).to be_valid
  end

  describe 'Restaurant' do
    let(:user) { create(:user) }
    let(:user2) { create(:user, email: 'test@test.com') }
    let(:restaurant) { create(:restaurant, user: user) }

    context 'deleting restaurant' do
      it 'can be deleted by the creator' do
        restaurant.destroy_as_user(user)
        expect(Restaurant.first).to be nil
      end

      it 'cannot be deleted by someone else' do
        restaurant.destroy_as_user(user2)
        expect(Restaurant.first).to eq restaurant
      end
    end

    context 'updating restaurant' do
      let(:restaurant_params) { { name: 'Potato' } }

      it 'can be updated by the creator' do
        restaurant.update_as_user(restaurant_params, user)
        expect(Restaurant.first.name).to eq('Potato')
      end

      it 'cannot be updated by someone else' do
        restaurant.update_as_user(restaurant_params, user2)
        expect(Restaurant.first.name).not_to eq('Potato')
      end
    end

  end

  describe 'Reviews' do
    describe 'build_with_user' do
      let(:user) { User.create(email: 'test@test.com') }
      let(:restaurant) { Restaurant.create(name: 'Test') }
      let(:review_params) { {rating: 5, thoughts: 'yum' } }

      subject(:review) { restaurant.reviews.build_with_user(review_params, user) }

      it 'builds a review' do
        expect(review).to be_a Review
      end

      it 'builds a review associated with the specified user' do
        expect(review.user).to eq user
      end
    end
  end

  describe '#average_rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        restaurant = Restaurant.create(name: 'The Ivy')
        expect(restaurant.average_rating).to eq('N/A')
      end
    end

    context '1 review' do
      it 'returns that rating' do
        user = create(:user)
        restaurant = Restaurant.create(name: 'The Ivy', user: user)
        restaurant.reviews.create(rating: 4)
        expect(restaurant.average_rating).to eq 4
      end
    end

    context 'multiple reviews' do
      it 'returns the average' do
        user = build(:user)
        user2 = create(:user, email: 'another@person.com')
        restaurant = create(:restaurant)
        restaurant.reviews.create(rating: 1, user: user)
        restaurant.reviews.create(rating: 5, user: user2)
        expect(restaurant.average_rating).to eq 3
      end
    end
  end

end