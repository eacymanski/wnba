# frozen_string_literal: true

class CreateTeam < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :location, null: false
      t.string :name, null: false
      t.boolean :is_active, default: true
      t.belongs_to :replaced_by, foreign_key: { to_table: :teams }
      t.timestamps
    end

    add_index :teams, %i[location name], unique: true
  end
end
