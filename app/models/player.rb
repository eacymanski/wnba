# frozen_string_literal: true

class Player < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_one :draft_pick
  belongs_to :current_team, class_name: 'Team', optional: true
end
