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

    def active_data
      all.group_by(&:year).transform_values do |picks|
        {total: picks.count, active: picks.count { |pick| pick.player&.is_active },
        rounds: picks.group_by(&:round).transform_values do |round_picks|
          {total: round_picks.count, active: round_picks.count { |pick| pick.player&.is_active }}
        end
        }
      end
    end
  end
end
