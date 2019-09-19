require "spec_helper"

RSpec.describe "Integration with RSpec's #be_nil matcher", type: :integration do
  context "assuming color is enabled" do
    it "produces the correct output" do
      program = make_plain_test_program(<<~TEST.strip)
        expect(:foo).to be_nil
      TEST

      expected_output = build_colored_expected_output(
        snippet: %|expect(:foo).to be_nil|,
        expectation: proc {
          line do
            plain "Expected "
            green %|:foo|
            plain " to be "
            red %|nil|
            plain "."
          end
        },
      )

      expect(program).to produce_output_when_run(expected_output)
    end
  end

  context "if color has been disabled" do
    it "does not include the color in the output" do
      program = make_plain_test_program(<<~TEST.strip, color_enabled: false)
        expect(:foo).to be_nil
      TEST

      expected_output = build_uncolored_expected_output(
        snippet: %|expect(:foo).to be_nil|,
        expectation: proc {
          line do
            plain "Expected "
            plain %|:foo|
            plain " to be "
            plain %|nil|
            plain "."
          end
        },
      )

      expect(program).to produce_output_when_run(expected_output)
    end
  end
end
