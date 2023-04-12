require 'rails_helper'

describe DailyLogEntry, type: :model do
  describe "relationships" do
    it {should belong_to :user}
  end
end