require 'rails_helper'

feature 'User can remove his answer attachments', %q{
  To correct errors.
  As the author of the question,
  I would like to delete the attached files to the question.
} do

  given(:author) {create(:user)}
  given(:user) {create(:user)}
  given(:question) {create(:question, user: author)}
  given(:answer) {create(:answer, question: question, user: author)}

  describe 'Authenticated user', js: true do
    before {sign_in(author)}
    before do
      add_file_to(answer)
      visit question_path(question)
      fill_in 'Answer', with: 'My answer'

      attach_file 'File', ["#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/spec_helper.rb').to_s}"]
      click_on 'Answer'
    end

    scenario 'author of the answer removes the attachment' do
      within ".attachment-#{answer.files.first.id}" do
        click_on 'remove'
      end

      within ".answer#{answer.id}" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'not author of the answer removes the attachment' do
      click_on 'Log out'
      sign_in(user)
      visit question_path(question)

      within ".attachment-#{answer.files.first.id}" do
        expect(page).to_not have_link 'remove'
      end
    end

    scenario 'Not authenticated user delete question attachment' do
      click_on 'Log out'
      visit question_path(question)

      within ".attachment-#{answer.files.first.id}" do
        expect(page).to_not have_link 'remove'
      end
    end
  end
end
