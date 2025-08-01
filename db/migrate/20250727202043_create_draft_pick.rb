# frozen_string_literal: true

class CreateDraftPick < ActiveRecord::Migration[8.0]
  def change
    create_table :draft_picks do |t|
      t.timestamps
      t.belongs_to :team, foreign_key: true, null: false
      t.belongs_to :player, foreign_key: true, null: false, index: { unique: true }
      t.belongs_to :college, foreign_key: true
      t.string :home_country
      t.integer :year, null: false
      t.integer :round, null: false
      t.integer :pick, null: false
    end

    add_index :draft_picks, %i[year round pick], unique: true
  end
end
