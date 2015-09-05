require 'rails_helper'

feature 'Endorsing reviews' do
  before do
    kfc = create(:restaurant)
    kfc_review = create(:review, rating: 3, thoughts: 'It was an abomination', restaurant: kfc)
  end

  context 'Endorsements counts correctly' do
    scenario 'a user can endorse a review, which updates the review endorsement count', js: true do
      visit '/restaurants'
      click_link 'Endorse Review'
      expect(page).to have_content('1 endorsement')
    end

    scenario 'Shows 2 counts' do
      visit '/restaurants'
      2.times { click_link 'Endorse Review' }
      expect(page).to have_content('2 endorsements')
    end
  end

end
