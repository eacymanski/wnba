# frozen_string_literal: true

class Player < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_one :draft_pick
end
