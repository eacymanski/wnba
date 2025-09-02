# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'validations and associations' do
    it { should validate_presence_of(:name) }

    it 'is invalid with a duplicative name' do
      create(:player, name: 'Air Bud')
      player = Player.new(name: 'Air Bud')
      expect(player).not_to be_valid
    end

    it { should have_one(:draft_pick) }
    it { should belong_to(:current_team).class_name('Team').optional }
  end
end
