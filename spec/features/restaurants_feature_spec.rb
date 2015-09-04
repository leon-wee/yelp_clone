require 'rails_helper'
require 'byebug'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      user = build(:user)
      sign_up_as(user)
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      user = build(:user)
      sign_up_as(user)
      visit('/restaurants')
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    before(:each) do
      user = create(:user)
      sign_in_as(user)
    end

    scenario 'prompts user to fill out a form, then displays the new restaurant if user is signed in' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content('KFC')
      expect(current_path).to eq '/restaurants'
    end

    scenario 'if not logged in, clicking add a restaurant redirects to log in page' do
      click_link('Sign out')
      visit('/restaurants')
      click_link('Add a restaurant')
      expect(current_path).to eq('/users/sign_in')
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do

    before(:each) do
      user = build(:user)
      sign_up_as(user)
      visit('/restaurants')
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'let a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
    end
  end

  context 'editing restaurants' do
    before(:each) do
      user = build(:user)
      sign_up_as(user)

      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'let a user edit a restaurant if they created it' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'should not let a user edit a restaurant if they did not create it' do
      click_link 'Sign out'
      sally = build(:user, email: "sally@sally.com")
      sign_up_as(sally)
      visit '/restaurants'
      click_link 'Edit KFC'
      expect(page).to have_content "You can only edit restaurants you have created."
    end
  end

  context 'deleting restaurants' do
    before(:each) do
      user = build(:user)
      sign_up_as(user)

      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'cannot remove restaurant if he is not the creator' do
      click_link 'Sign out'
      sally = build(:user, email: "sally@sally.com")
      sign_up_as(sally)
      visit('/restaurants')
      click_link 'Delete KFC'
      expect(page).to have_content "You can only delete restaurants you have created."
    end
  end
end