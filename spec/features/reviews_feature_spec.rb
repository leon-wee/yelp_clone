require 'rails_helper'

feature 'reviewing' do
  context 'Leaving a review' do
    before(:each) do
      user = build(:user)
      sign_up_as(user)
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'allows users to leave a review using a form' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'

      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
    end

    scenario 'users can only leave one review per restaurant' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'hahahaha'
      click_button 'Leave Review'
      expect(page).to have_content('You have already reviewed this restaurant')
    end
  end

  context 'Deleting a review' do
    before(:each) do
      user = build(:user)
      sign_up_as(user)
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end

    scenario 'users will see the delete review link' do
      expect(page).to have_link('Delete Review')
    end

    scenario 'creator can delete the link' do
      within 'ul#reviews li:nth-child(1)' do
        click_link('Delete Review')
      end
      expect(page).not_to have_content('so so')
      expect(page).to have_content('Successfully deleted review')
    end

    scenario 'non-creator cannot delete the link' do
      click_link('Sign out')
      user2 = build(:user, email: 'adrianispotato@potato.com')
      sign_up_as(user2)
      within 'ul#reviews li:nth-child(1)' do
        click_link('Delete Review')
      end
      expect(page).to have_content('You cannot delete the review')
    end
  end

end