require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:author) { create(:user) }
  let(:voters) { create_list(:user, 5) }

  let(:votable) do
    if model.to_s == 'Answer'
      question = create(:question, user: author)
      create(model.to_s.underscore.to_sym, question: question, user: author)
    else
      create(model.to_s.underscore.to_sym, user: author)
    end
  end

  describe '#rating_up' do
    before { votable.rating_up(voters[0]) }

    it 'changed raiting' do
      expect(Vote.last.rating).to eq 1
    end

    it 'vote user is a @voter' do
      expect(Vote.last.user).to eq voters[0]
    end

    it 'vote votable is a @votable' do
      expect(Vote.last.votable).to eq votable
    end
  end

  describe '#rating_down' do
    before { votable.rating_down(voters[0]) }

    it 'changed raiting' do
      expect(Vote.last.rating).to eq -1
    end

    it 'vote user is a @voter' do
      expect(Vote.last.user).to eq voters[0]
    end

    it 'vote votable is a @votable' do
      expect(Vote.last.votable).to eq votable
    end
  end

  it '#rating_sum' do
    votable.rating_up(voters[0])
    votable.rating_up(voters[1])
    votable.rating_up(voters[2])
    votable.rating_down(voters[3])
    votable.rating_down(voters[4])

    expect(votable.rating_sum).to eq 1
  end
end
