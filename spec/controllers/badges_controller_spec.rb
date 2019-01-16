require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:badges) { create_list(:badge, 8, question: question, user: user) }

    before { login(user) }
    before { get :index }

    it 'fill an array of badges' do
      expect(assigns(:badges)).to match_array(badges)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
