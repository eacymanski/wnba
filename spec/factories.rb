# frozen_string_literal: true

FactoryBot.define do
  factory :college do
    name { Faker::University.name }
  end

  factory :player do
    name { Faker::Name.name }
  end

  factory :team do
    location { Faker::Address.city }
    name { Faker::Creature::Animal.name }
  end

  factory :draft_pick do
    college
    player
    team
    year { 2025 }
    round { 1 }
    pick { 7 }
  end
end
