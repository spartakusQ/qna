require 'rails_helper'

feature 'User can create answer', %q{
  As an authenticated user
  The user, being on the question page,
  can write the answer to the question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    scenario 'answer the question' do
      sign_in(user)

      visit question_path(question)

      fill_in 'Answer', with: 'My answer'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'My answer'
      end
    end


    scenario 'answer the question with add files' do
      sign_in(user)

      visit question_path(question)

      fill_in 'Answer', with: 'My answer'

      attach_file 'File', ["#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/spec_helper.rb').to_s}"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answer the question with error', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'non authenticated user answer a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
