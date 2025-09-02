# frozen_string_literal: true

require 'rails_helper'

describe IntakeDrafts do
  context 'when intaking a good year draft' do
    before do
      allow(Net::HTTP).to receive(:get_response).and_return(
        instance_double(Net::HTTPResponse, code: '200',
                                           body: File.read(Rails.root.join('spec', 'fixtures', 'drafts', '2025.html')))
      )
    end

    subject { IntakeDrafts.intake([2025]) }

    it 'intakes draft data without errors' do
      expect { subject }.not_to raise_error
    end

    it 'creates the correct number of draft picks' do
      expect { subject }.to change { DraftPick.count }.by(38) # aces lost their first round pick
    end

    it 'calls wnba draft board for the correct year' do
      expect(Net::HTTP).to receive(:get_response).with(URI('https://www.wnba.com/draft/2025/board'))
      subject
    end

    it 'saves player, college, and team data correctly' do
      subject
      first_pick = DraftPick.find_by(year: 2025, round: 1, pick: 1)
      expect(first_pick.player.name).to eq('Paige Bueckers')
      expect(first_pick.college.name).to eq('UConn')
      expect(first_pick.team.location).to eq('Dallas')
    end
  end

  context 'when intaking a missing draft board' do
    before do
      allow(Net::HTTP).to receive(:get_response).and_return(
        instance_double(Net::HTTPResponse, code: '404', body: '')
      )
    end

    subject { IntakeDrafts.intake([2010]) }

    it 'handles bad draft page without errors' do
      expect { subject }.not_to raise_error
    end

    it 'does not create any draft picks' do
      expect { subject }.not_to(change { DraftPick.count })
    end

    it 'outputs message' do
      expect { subject }.to output(/bad draft page for 2010/).to_stdout
    end
  end
end
