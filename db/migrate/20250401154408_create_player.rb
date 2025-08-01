# frozen_string_literal: true

class CreatePlayer < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
