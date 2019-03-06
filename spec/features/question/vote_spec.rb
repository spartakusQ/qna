require 'rails_helper'

feature 'User can vote for the question', %q{
  In order to express favor to author of question
  As an authenticated user
  I'd like to be able to vote for the question
} do

  given(:author) { create(:user) }
  given(:any_auth_user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user', js: true do

    scenario 'author not vote up' do
      sign_in(author)
      visit question_path(question)

      within '.question, .vote' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'non author can vote up' do
      sign_in(any_auth_user)
      visit question_path(question)

      within '.vote' do
        find('.vote-up-button').click

        expect(page).to have_content '1'
      end
    end

    scenario 'non author can vote up only once' do
      sign_in(any_auth_user)
      visit question_path(question)

      within '.vote' do
        find('.vote-up-button').click

        expect(page).to_not have_link '+'
        expect(page).to have_content '1'
      end
    end

    scenario 'non author can vote down only once' do
      sign_in(any_auth_user)
      visit question_path(question)

      within '.vote' do
        find('.vote-down-button').click

        expect(page).to_not have_link '-'
        expect(page).to have_content '-1'
      end
    end

    scenario 'non author can vote down' do
      sign_in(any_auth_user)
      visit question_path(question)

      within '.vote' do
        find('.vote-down-button').click
        expect(page).to have_content '-1'
      end
    end

    scenario 'non author can revote' do
      sign_in(any_auth_user)
      visit question_path(question)

      within '.vote' do
        find('.vote-down-button').click
        expect(page).to have_link 'revote'

        click_on 'revote'
        expect(page).to_not have_link 'revote'
      end
    end

    scenario "can't vote for self answer" do
      sign_in(author)
      visit question_path(question)

      within '.question, .vote' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end
  end
end
