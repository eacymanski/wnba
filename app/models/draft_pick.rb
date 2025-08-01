# frozen_string_literal: true

class DraftPick < ApplicationRecord
  validates :year, :round, :pick, presence: true
  validates :pick, uniqueness: { scope: %i[round year] }
  validates :player, uniqueness: true

  belongs_to :player
  belongs_to :team
  belongs_to :college, optional: true
end
