require 'rails_helper'

describe User, type: :model do
  it { is_expected.to have_many :restaurants }
  it { is_expected.to have_many :reviews }

  it { is_expected.to have_many :reviewed_restaurants }

  describe 'Users' do
    describe 'build_with_user' do
      let(:user) { User.create(email: 'test@test.com') }
      let(:restaurant_params) { {name: 'kfc'} }

      subject(:restaurant) { user.restaurants.build_with_user(restaurant_params, user) }

      it 'builds a review' do
        expect(restaurant).to be_a Restaurant
      end

      it 'builds a review associated with the specified user' do
        expect(restaurant.user).to eq user
      end
    end
  end
end