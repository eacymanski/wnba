# frozen_string_literal: true

class DraftPick < ApplicationRecord
  validates_presence_of :year, :round, :pick
  validates :pick, uniqueness: { scope: %i[round year] }
  validates :player, uniqueness: true

  belongs_to :player
  belongs_to :team
  belongs_to :college, optional: true

  class << self
    def rounds_for_year(year)
      where(year: year).distinct.pluck(:round).sort
    end

    def years
      distinct.pluck(:year).sort
    end

    def picks_for_round(year, round)
      where(year: year, round: round).order(:pick)
    end

    def most_recent_year
      maximum(:year)
    end

    def valid_year?(year)
      exists?(year: year)
    end

    def valid_round?(year, round)
      exists?(year: year, round: round)
    end

    def copilot_grouped_picks
      all.group_by(&:year).transform_values do |picks|
        picks.group_by(&:round).transform_values do |round_picks|
          round_picks.sort_by(&:pick)
        end
      end
    end

    def grouped_picks
      years.map do |year|
        { year: year, rounds: rounds_for_year(year).map do |round|
          { round: round, picks: picks_for_round(year, round) }
        end }
      end
    end
  end
end
