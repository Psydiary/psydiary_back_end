require 'rails_helper'

describe MicrodoseLogEntry, type: :model do
  describe "relationships" do
    it {should belong_to :user}
  end
end