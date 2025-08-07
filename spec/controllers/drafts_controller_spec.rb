# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DraftsController, type: :controller do
  describe 'GET #show' do
    before do
      create(:draft_pick, year: 2022, round: 2)
      create(:draft_pick, year: 2021, round: 1)
    end

    context 'with valid year and round' do
      let!(:draft_pick_2) { create(:draft_pick, year: 2022, round: 1, pick: 2) }
      let!(:draft_pick_1) { create(:draft_pick, year: 2022, round: 1, pick: 1) }

      it 'assigns @rounds, @years, and @draft_picks' do
        get :show, params: { year: 2022, round: 1 }
        expect(assigns(:rounds)).to eq [1, 2]
        expect(assigns(:years)).to eq [2021, 2022]
        expect(assigns(:draft_picks)).to eq [draft_pick_1, draft_pick_2]
      end
    end

    context 'with invalid year' do
      it 'renders unprocessable_entity status' do
        get :show, params: { year: 1800 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:error]).to eq('Invalid Year: 1800')
      end
    end

    context 'with invalid round' do
      it 'renders unprocessable_entity status' do
        get :show, params: { year: 2022, round: 10 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:error]).to eq('Invalid Round (10) for 2022')
      end
    end
  end
end
