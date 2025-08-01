# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid with name' do
    player = Player.new(name: 'Air Bud')
    expect(player).to be_valid
  end

  it 'is invalid without name' do
    player = Player.new
    expect(player).not_to be_valid
  end

  it 'is invalid with a duplicative name' do
    create(:player, name: 'Air Bud')
    player = Player.new(name: 'Air Bud')
    expect(player).not_to be_valid
  end
end
