# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, :location, presence: true
  validates :name, uniqueness: { scope: :location }

  has_many :draft_picks
  belongs_to :replaced_by, class_name: 'Team', optional: true
  has_many :current_players, class_name: 'Player', foreign_key: 'current_team_id'
end
