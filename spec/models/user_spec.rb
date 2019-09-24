require 'rails_helper'

RSpec.describe User, type: :model do
  it "should not save empty role" do
    role = Role.new
    expect role.save == false
  end
end
