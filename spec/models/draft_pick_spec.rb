# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DraftPick, type: :model do
  describe 'validations and associations' do
    let!(:player) { create(:player) }
    let!(:team) { create(:team) }
    let!(:college) { create(:college) }

    it { should belong_to(:player) }
    it { should belong_to(:team) }
    it { should belong_to(:college).optional }

    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:round) }
    it { should validate_presence_of(:pick) }

    it 'is invalid with duplicative player' do
      create(:draft_pick, player: player)
      draft_pick = DraftPick.new(player: player, team: team, year: 2025, round: 1, pick: 12)
      expect(draft_pick).not_to be_valid
    end

    it 'is invalid with duplicative year, round, pick' do
      create(:draft_pick, year: 2024, round: 1, pick: 1)
      draft_pick = DraftPick.new(player: player, team: team, year: 2024, round: 1, pick: 1)
      expect(draft_pick).not_to be_valid
    end

    it 'is valid with only matching year & round' do
      create(:draft_pick, year: 2024, round: 1, pick: 1)
      draft_pick = DraftPick.new(player: player, team: team, year: 2024, round: 1, pick: 2)
      expect(draft_pick).to be_valid
    end

    it 'is valid with only matching year & pick' do
      create(:draft_pick, year: 2024, round: 1, pick: 1)
      draft_pick = DraftPick.new(player: player, team: team, year: 2024, round: 2, pick: 1)
      expect(draft_pick).to be_valid
    end

    it 'is valid with only matching round & pick' do
      create(:draft_pick, year: 2024, round: 1, pick: 1)
      draft_pick = DraftPick.new(player: player, team: team, year: 2022, round: 1, pick: 1)
      expect(draft_pick).to be_valid
    end
  end

  describe 'class methods' do
    it 'returns correct rounds for year' do
      create(:draft_pick, year: 2023, round: 1)
      create(:draft_pick, year: 2023, round: 2)
      create(:draft_pick, year: 2022, round: 3)
      expect(DraftPick.rounds_for_year(2023)).to eq([1, 2])
    end

    it 'returns correct years' do
      create(:draft_pick, year: 2021)
      create(:draft_pick, year: 2022)
      create(:draft_pick, year: 2023)
      expect(DraftPick.years).to eq([2021, 2022, 2023])
    end

    it 'returns correct picks for round' do
      pick2 = create(:draft_pick, year: 2024, round: 1, pick: 2)
      pick1 = create(:draft_pick, year: 2024, round: 1, pick: 1)
      create(:draft_pick, year: 2024, round: 2, pick: 1)
      expect(DraftPick.picks_for_round(2024, 1)).to eq([pick1, pick2])
    end

    it 'returns most recent year' do
      create(:draft_pick, year: 2020)
      create(:draft_pick, year: 2022)
      create(:draft_pick, year: 2021)
      expect(DraftPick.most_recent_year).to eq(2022)
    end

    it 'validates year correctly' do
      create(:draft_pick, year: 2025)
      expect(DraftPick.valid_year?(2025)).to be true
      expect(DraftPick.valid_year?(2024)).to be false
    end

    it 'validates round correctly' do
      create(:draft_pick, year: 2023, round: 2)
      expect(DraftPick.valid_round?(2023, 2)).to be true
      expect(DraftPick.valid_round?(2023, 1)).to be false
      expect(DraftPick.valid_round?(2022, 2)).to be false
    end

    it 'returns correct active data' do
      active_player_1 = create(:player, is_active: true)
      active_player_2 = create(:player, is_active: true)
      inactive_player_1 = create(:player, is_active: false)
      inactive_player_2 = create(:player, is_active: false)
      create(:draft_pick, year: 2023, round: 1, player: active_player_1)
      create(:draft_pick, year: 2023, round: 1, player: inactive_player_1)
      create(:draft_pick, year: 2023, round: 2, player: active_player_2)
      create(:draft_pick, year: 2022, round: 1, player: inactive_player_2)

      expected_data = {
        2022 => { total: 1, active: 0, rounds: { 1 => { total: 1, active: 0 } } },
        2023 => { total: 3, active: 2,
                  rounds: {
                    1 => { total: 2, active: 1 },
                    2 => { total: 1, active: 1 }
                  } }
      }

      expect(DraftPick.active_data).to eq(expected_data)
    end
  end
end
