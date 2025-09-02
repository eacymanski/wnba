# frozen_string_literal: true

class AddColumnsToPlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :wnba_id, :integer
    add_column :players, :wnba_slug, :string
    add_column :players, :is_active, :boolean, default: false
    add_reference :players, :current_team, foreign_key: { to_table: :teams }, index: true
  end
end
