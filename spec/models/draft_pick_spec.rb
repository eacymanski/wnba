# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DraftPick, type: :model do
  let!(:player) { create(:player) }
  let!(:team) { create(:team) }
  let!(:college) { create(:college) }

  it 'is valid with player, team and pick values' do
    draft_pick = DraftPick.new(player: player, team: team, year: 2025, round: 1, pick: 12)
    expect(draft_pick).to be_valid
  end

  it 'is invalid without player' do
    draft_pick = DraftPick.new(team: team, year: 2025, round: 1, pick: 12)
    expect(draft_pick).not_to be_valid
  end

  it 'is invalid without team' do
    draft_pick = DraftPick.new(player: player, year: 2025, round: 1, pick: 12)
    expect(draft_pick).not_to be_valid
  end

  it 'is invalid without year' do
    draft_pick = DraftPick.new(player: player, team: team, round: 1, pick: 12)
    expect(draft_pick).not_to be_valid
  end

  it 'is invalid without round' do
    draft_pick = DraftPick.new(player: player, team: team, year: 2025, pick: 12)
    expect(draft_pick).not_to be_valid
  end

  it 'is invalid without pick' do
    draft_pick = DraftPick.new(player: player, team: team, year: 2025, round: 1)
    expect(draft_pick).not_to be_valid
  end

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
