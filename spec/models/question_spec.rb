require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'validates presence of title' do
    question = Question.new(body: '123')
    expect(question).to_not be_valid
  end

  it 'validates presence of body' do
    question = Question.new(title: '123')
    expect(question).to_not be_valid
  end
end
