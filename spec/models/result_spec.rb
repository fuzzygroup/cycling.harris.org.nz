describe "Result" do

  let(:result) { FactoryGirl.build(:result) }

  describe "validations" do
    it "is valid" do
      expect(result).to be_valid
    end

    it "is not valid without user" do
      result.user = nil
      expect(result).not_to be_valid
    end
  end

  describe "#find_previous_result" do
    let(:race) { FactoryGirl.create(:race) }
    let(:other_race) { FactoryGirl.create(:race, name: 'Other Race') }

    let!(:result) { FactoryGirl.create(:result, race: race, date: Date.parse('2014-10-8')) }
    let!(:last_year) { FactoryGirl.create(:result, race: race, date: Date.parse('2013-10-5')) }

    before {
      FactoryGirl.create(:result, race: other_race, date: Date.parse('2013-10-5'))
      FactoryGirl.create(:result, race: race, date: Date.parse('2012-10-7'))
    }
    
    it "find last years result" do
      expect(result.find_previous_result).to eq last_year
    end
  end

  describe "#time_difference_between_previous" do
    let(:result) { FactoryGirl.build(:result, duration: 30) }

    it "returns a postive time difference if faster than last year" do
      allow(result).to receive_message_chain(:find_previous_result, :duration) { 40 }

      expect(result.time_difference_between_previous).to eq(10)
    end

    it "returns a negative time difference if slower than last year" do
      allow(result).to receive_message_chain(:find_previous_result, :duration) { 20 }
      
      expect(result.time_difference_between_previous).to eq(-10)
    end

    it "returns nil if previous result not found" do
      allow(result).to receive(:find_previous_result) { nil }
      
      expect(result.time_difference_between_previous).to be_nil
    end
  end
end