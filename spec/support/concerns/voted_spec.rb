require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:voter) { create(:user) }
  let(:author) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }

  describe 'POST #rating_up' do
    context 'current user is not author of resource' do
      before { login(voter) }

      let!(:user_votable) { voted(model, author) }

      it 'try to vote up' do
        expect { post :rating_up, params: { id: user_votable } }.to change(Vote, :count)
      end

      it 'try vote two times from one resource' do
        post :rating_up, params: { id: user_votable }
        expect { post :rating_up, params: { id: user_votable } }.to_not change(Vote, :count)
      end
    end

    context 'current user is author of resource' do
      before { login(author) }

      let!(:user_votable) { voted(model, author) }

      it 'can not add new vote' do
        expect { post :rating_up, params: { id: user_votable } }.to_not change(Vote, :count)
      end
    end

    describe 'POST #rating_down' do
      context 'current user is not author of resource' do
        before { login(voter) }

        let!(:user_votable) { voted(model, author) }

        it 'try vote down' do
          expect { post :rating_down, params: { id: user_votable } }.to change(Vote, :count)
        end
      end
    end

    context 'current user is author of resource' do
      before { login(author) }

      let!(:user_votable) { voted(model, author) }

      it 'can not add new disvote' do
        expect { post :rating_down, params: { id: user_votable } }.to_not change(Vote, :count)
      end
    end

    describe 'DELETE #revote' do
      context 'current user revote his vote' do
        before { login(voter) }

        let!(:user_votable) { voted(model, author) }

        it 'delete vote' do
          post :rating_up, params: { id: user_votable }
          expect { delete :revote, params: { id: user_votable } }.to change(Vote, :count).by(-1)
        end
      end

      context 'current user' do
        let(:new_user) { create(:user) }
        let!(:new_vote) { voted(model, new_user) }

        it 'try to revote vote of other user' do
          expect { delete :revote, params: { id: new_vote } }.to_not change(Vote, :count)
        end
      end
    end
  end
end
