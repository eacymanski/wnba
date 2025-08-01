# frozen_string_literal: true

require 'rails_helper'

RSpec.describe College, type: :model do
  it 'is valid with name' do
    college = College.new(name: 'Ohio State University')
    expect(college).to be_valid
  end

  it 'is invalid without name' do
    college = College.new
    expect(college).not_to be_valid
  end

  it 'is invalid with a duplicative name' do
    create(:college, name: 'Ohio State University')
    college = College.new(name: 'Ohio State University')
    expect(college).not_to be_valid
  end
end
