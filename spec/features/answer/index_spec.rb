require 'rails_helper'

feature 'User can view the question and answers to it.' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 8, question: question, user: user) }

  scenario 'visit to answers list on the question page' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
