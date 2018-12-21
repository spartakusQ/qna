require 'rails_helper'

feature 'Choose best answer', %q{
  the answer may be the best
  the user himself can non set the best question to answer
  only authorized user can vote
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:first_answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }
  given!(:third_answer) { create(:answer, question: question, user: user) }


  scenario 'unauthorized user or author cannot vote best answe' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose the best'
  end

  describe 'User is author question', js: true do
    before { sign_in user }
    before { visit question_path(question) }

    scenario 'best answer link not available for best answer' do
      within(".answer#{first_answer.id}") do
        click_on 'Choose the best'

        expect(page).to_not have_link 'Choose the best'
        expect(page).to have_content 'BestAnswer'
      end

      within(".answer#{second_answer.id}") do
        expect(page).to have_link 'Choose the best'
      end
    end

    scenario 'best answer first in list' do
      expect(third_answer).to_not eq question.answers.first

      within(".answer#{third_answer.id}") do
        click_on 'Choose the best'

        expect(page).to_not have_link 'Choose the best'
      end

      third_answer.reload
      expect(third_answer).to eq question.answers.first
    end
  end
end
