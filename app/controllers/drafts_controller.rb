# frozen_string_literal: true

class DraftsController < ApplicationController
  before_action :validate_year, :validate_round

  def show
    @rounds = DraftPick.rounds_for_year(@year)
    @years = DraftPick.years
    @draft_picks = DraftPick.picks_for_round(@year, @round)
  end

  private

  def validate_year
    @year = params[:year] || DraftPick.most_recent_year
    return if DraftPick.valid_year?(@year)

    flash.now[:error] = "Invalid Year: #{@year}"
    render status: :unprocessable_entity
  end

  def validate_round
    @round = params[:round] || 1
    return if DraftPick.valid_round?(@year, @round)

    flash.now[:error] = "Invalid Round (#{@round}) for #{@year}"
    render status: :unprocessable_entity
  end
end
