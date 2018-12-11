require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'adding new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(question.answers, :count)
      end

      it 'render new view path' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'editing the selected answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end


  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'aasigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid) } }
      it 'does not change question' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question
    end
  end
end
