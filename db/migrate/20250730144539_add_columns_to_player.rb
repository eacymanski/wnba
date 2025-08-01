# frozen_string_literal: true

class AddColumnsToPlayer < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :wnba_id, :integer
    add_column :players, :wnba_slug, :string
  end
end
