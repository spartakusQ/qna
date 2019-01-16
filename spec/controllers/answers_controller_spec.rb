require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'user at login in' do

      context 'with valid attributes' do
        it 'save new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'check for user log in answer author' do
          post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
          expect(assigns(:answer).user).to eq user
        end

        it 'redirect to question show view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end

      it 'assign created answer by current user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer).user).to eq user
      end

      context 'with invalid attributes' do
        it 'not save the answer' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
        end

        it 'render new view path' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'user at not login in' do
      let!(:not_user) { create(:user) }
      before { login(not_user) }

      context 'with valid attributes' do
        it 'save new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
        end
      end

      context 'with invalid attributes' do
        it 'not save the answer' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
        end

        it 'render new view path' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end
    end

  end

  describe 'PATCH #update' do
    let(:author) { create(:user) }
    let!(:author_answer) { create(:answer, question: question, user: author) }

    context 'with valid attributes' do
      before { login(author) }

      it 'changes answer attributes' do
        patch :update, params: { id: author_answer, answer: { body: 'new body' } }, format: :js
        author_answer.reload
        expect(author_answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response.status).to eq(403)
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: author_answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(author_answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: author_answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    context 'user an author' do
      before { login(user) }
      let!(:question) { create(:question, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end

    end

    context 'user is not author' do
      let!(:not_user) { create(:user) }

      before { login(not_user) }
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATCH #best' do
    let(:author) { create(:user) }
    let(:answer_author) { create(:user) }
    let!(:new_question) { create(:question, user: author) }
    let!(:badge) { create(:badge, question: new_question) }
    let!(:answer) { create(:answer, question: new_question, user: answer_author) }

    context 'user an author answer' do
      before { login(author) }
      before { patch :best, params: { id: answer, format: :js } }

      it 'assigns the request answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question badge to user badge' do
        expect(badge).to eq answer_author.badges.last
      end

      it 'renders answer best' do
        expect(response).to render_template :best
      end
    end
  end
end
