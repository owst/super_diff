require "spec_helper"

RSpec.describe SuperDiff, type: :unit do
  describe ".inspect_object" do
    let(:range) { (1..10) }

    it "shows the Range via inspect" do
      actual = described_class.inspect_object(range, as_lines: false)

      expect(actual).to eq(range.inspect)
    end
  end
end
