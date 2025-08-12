# frozen_string_literal: true

module DraftsHelper
  def count_active_players(picks)
    picks.count { |pick| pick.player.is_active }
  end
end
