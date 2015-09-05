require 'rails_helper'

feature 'Endorsing reviews' do
  before do
    kfc = create(:restaurant)
    kfc_review = create(:review, rating: 3, thoughts: 'It was an abomination', restaurant: kfc)
  end

  context 'Endorsements counts correctly', js: true do
    scenario 'starts with 0 endorsements' do
      visit '/restaurants'
      expect(page).to have_content('0 endorsements')
    end

    scenario 'a user can endorse a review, which updates the review endorsement count' do
      visit '/restaurants'
      click_link 'Endorse'
      expect(page).to have_content('1 endorsement')
    end
  end

end
