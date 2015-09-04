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


end