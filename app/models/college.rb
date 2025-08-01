# frozen_string_literal: true

class College < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :draft_picks
end
