require 'rails_helper'

feature 'User can vote for the question', %q{
  In order to express favor to author of question
  As an authenticated user
  I'd like to be able to vote for the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }
    before { visit question_path(question) }

    scenario 'try to vote for the question' do
      within('.question') do
        click_on '+'
        expect(page).to have_content '1'
      end
    end

    scenario 'try to vote for the question two times' do
      within('.question') do
        click_on '+'
        click_on '+'
        expect(page).to have_content '1'
      end
    end
  end
end
