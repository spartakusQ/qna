require 'rails_helper'

feature 'User can log out' do
  given(:user) { create(:user) }
  
  scenario 'Registered User can log out' do
    sign_in(user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
