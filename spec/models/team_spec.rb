# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validations and associations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }

    it 'is invalid with a duplicative location and name' do
      create(:team, location: 'Cleveland', name: 'Rockers')
      team = Team.new(location: 'Cleveland', name: 'Rockers')
      expect(team).not_to be_valid
    end

    it 'is valid with only matching location' do
      create(:team, location: 'San Antonio', name: 'Silver Stars')
      team = Team.new(location: 'San Antonio', name: 'Stars')
      expect(team).to be_valid
    end

    it 'is valid with only matching name' do
      create(:team, location: 'Detriot', name: 'Shock')
      team = Team.new(location: 'Tulsa', name: 'Shock')
      expect(team).to be_valid
    end

    it 'defaults is_active to true' do
      team = Team.create(location: 'Golden State', name: 'Valkyries')
      expect(team.is_active).to be true
    end

    it { should have_many(:draft_picks) }
    it { should belong_to(:replaced_by).class_name('Team').optional }
    it { should have_many(:current_players).class_name('Player').with_foreign_key('current_team_id') }
  end
end
