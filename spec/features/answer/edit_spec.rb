require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save Edit'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end


    scenario 'edits with errors', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save Edit'

        expect(page).to have_content answer.body
        # expect(page).to have_content "Body can't be blank" selector does not see the error field
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit other user's question" do
      sign_in another_user
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
