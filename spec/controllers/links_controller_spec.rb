require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:link_question) { create(:link, linkable: question) }
  let!(:link_answer) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    before { login(author) }

    context 'user an author' do

      it 'delete question link' do
        expect { delete :destroy,  params: { id: link_question.id }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'return to question form after delete question link' do
        delete :destroy, params: { id: link_question }, format: :js
        expect(response).to render_template :destroy
      end

      it 'delete answer link' do
        expect { delete :destroy, params: { id: link_answer }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'return to answer form after delete answer link' do
        delete :destroy, params: { id: link_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user not author' do
      before { login(user) }

      it 'try delete the question link' do
        expect { delete :destroy, params: { id: link_question }, format: :js }.to_not change(Link, :count)
      end

      it 'try delete the answer link' do
        expect { delete :destroy, params: { id: link_answer }, format: :js }.to_not change(Link, :count)
      end
    end
  end
end
