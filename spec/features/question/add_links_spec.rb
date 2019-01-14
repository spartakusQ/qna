require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given(:some_url) {'https://github.com/'}

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link', with: 'My gist'
    fill_in 'Url', with: some_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: some_url
  end

end
