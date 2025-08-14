# frozen_string_literal: true

require 'rails_helper'

describe IntakeRosters do
  describe '.update_current_rosters' do
    before do
      allow(Net::HTTP).to receive(:get_response).and_return(
        instance_double(
          Net::HTTPResponse,
          code: '200',
          body: File.read(Rails.root.join('spec', 'fixtures', 'rosters', 'players.html'))
        )
      )
    end

    let!(:existing_player) { create(:player, wnba_id: 1_642_777) }
    let!(:old_player) { create(:player, wnba_id: 99_999, is_active: true) }
    let!(:player_without_id) { create(:player, name: 'Georgia Amoore') }

    subject { IntakeRosters.intake }

    it 'intakes player data without errors' do
      expect { subject }.not_to raise_error
    end

    it 'updates existing player active status and current team correctly' do
      subject
      existing_player.reload
      expect(existing_player.is_active).to be true
      expect(existing_player.current_team).to eq Team.find_by(location: 'Phoenix')
    end

    it 'updates existing player without id active status and current team correctly' do
      subject
      player_without_id.reload
      expect(player_without_id.wnba_id).to eq 1_642_781
      expect(player_without_id.wnba_slug).to eq 'georgia-amoore'
      expect(player_without_id.is_active).to be true
      expect(player_without_id.current_team).to eq Team.find_by(location: 'Washington')
    end

    it 'creates new players correctly and sets active status and current team correctly' do
      expect { subject }.to change { Player.count }.by(5) # Five new players in the fixture data
      new_player = Player.find_by(wnba_id: 1_627_700)
      expect(new_player.name).to eq 'Julie Allemand'
      expect(new_player.wnba_slug).to eq 'julie-allemand'
      expect(new_player.is_active).to be true
      expect(new_player.current_team).to eq Team.find_by(location: 'Los Angeles')
    end

    it 'deactivates players not in the current roster' do
      subject
      old_player.reload
      expect(old_player.is_active).to be false
      expect(old_player.current_team).to be_nil
    end

    it 'calls WNBA player list URL' do
      expect(Net::HTTP).to receive(:get_response).with(URI('https://www.wnba.com/players?team=all&position=all'))
      subject
    end
  end
end
