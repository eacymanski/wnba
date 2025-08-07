# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  it 'is valid with name and location' do
    team = Team.new(location: 'Cleveland', name: 'Rockers', is_active: false)
    expect(team).to be_valid
  end

  it 'is invalid without name' do
    team = Team.new(location: 'Boston')
    expect(team).not_to be_valid
  end

  it 'is invalid without location' do
    team = Team.new(name: 'Leprechauns')
    expect(team).not_to be_valid
  end

  it 'defaults is_active to true' do
    team = Team.create(location: 'Golden State', name: 'Valkyries')
    expect(team.is_active).to be true
  end

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

  it 'sets replaced by team correctly' do
    detriot = create(:team, location: 'Detriot', name: 'Shock')
    tulsa = Team.new(location: 'Tulsa', name: 'Shock')
    detriot.update(replaced_by: tulsa)
    expect(detriot.replaced_by).to eq tulsa
  end
end
