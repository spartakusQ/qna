require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) { create(:question, user: user) }
  given(:some_url) {'https://github.com/'}

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Answer', with: 'My answer'

    fill_in 'Link', with: 'My gist'
    fill_in 'Url', with: some_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: some_url
    end
  end

end
