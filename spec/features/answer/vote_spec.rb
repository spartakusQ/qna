require 'rails_helper'

feature 'User can vote for the answer', %q{
  In order to express favor to author of answer
  As an authenticated user
  I'd like to be able to vote for the answer
} do

  given(:author) { create(:user) }
  given(:any_auth_user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user', js: true do

    scenario 'author not vote up' do
      sign_in(author)
      visit question_path(question)

      within ".answer#{answer.id}" do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'non author can vote up' do
      sign_in(any_auth_user)
      visit question_path(question)

      within ".answer#{answer.id}" do
        click_on '+'
        expect(page).to have_content '1'
      end
    end

    scenario 'non author can vote down' do
      sign_in(any_auth_user)
      visit question_path(question)

      within ".answer#{answer.id}" do
        click_on '-'
        expect(page).to have_content '-1'
      end
    end

    scenario "can't vote for self answer" do
      sign_in(author)
      visit question_path(question)

      within ".answer#{answer.id}" do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end
  end
end
