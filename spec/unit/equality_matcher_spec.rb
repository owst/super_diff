require "spec_helper"

RSpec.describe SuperDiff::EqualityMatcher do
  describe "#call" do
    context "given the same integers" do
      it "returns an empty string" do
        output = described_class.call(expected: 1, actual: 1)

        expect(output).to eq("")
      end
    end

    context "given the same numbers (even if they're different types)" do
      it "returns an empty string" do
        output = described_class.call(expected: 1, actual: 1.0)

        expect(output).to eq("")
      end
    end

    context "given differing numbers" do
      it "returns a message along with a comparison" do
        actual_output = described_class.call(expected: 42, actual: 1)

        expected_output = <<~STR.strip
          Differing numbers.

          #{
            colored do
              red_line   %(Expected: 42)
              green_line %(  Actual: 1)
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given the same symbol" do
      it "returns an empty string" do
        output = described_class.call(expected: :foo, actual: :foo)

        expect(output).to eq("")
      end
    end

    context "given differing symbols" do
      it "returns a message along with a comparison" do
        actual_output = described_class.call(expected: :foo, actual: :bar)

        expected_output = <<~STR.strip
          Differing symbols.

          #{
            colored do
              red_line   %(Expected: :foo)
              green_line %(  Actual: :bar)
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given the same string" do
      it "returns an empty string" do
        output = described_class.call(expected: "", actual: "")

        expect(output).to eq("")
      end
    end

    context "given completely different single-line strings" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: "Marty",
          actual: "Jennifer"
        )

        expected_output = <<~STR.strip
          Differing strings.

          #{
            colored do
              red_line   %(Expected: "Marty")
              green_line %(  Actual: "Jennifer")
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given closely different single-line strings" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: "Marty",
          actual: "Marty McFly"
        )

        expected_output = <<~STR.strip
          Differing strings.

          #{
            colored do
              red_line   %(Expected: "Marty")
              green_line %(  Actual: "Marty McFly")
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given closely different multi-line strings" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: "This is a line\nAnd that's a line\nAnd there's a line too",
          actual: "This is a line\nSomething completely different\nAnd there's a line too"
        )

        expected_output = <<~STR.strip
          Differing strings.

          #{
            colored do
              red_line   %(Expected: "This is a line⏎And that's a line⏎And there's a line too")
              green_line %(  Actual: "This is a line⏎Something completely different⏎And there's a line too")
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  This is a line⏎)
              red_line   %(- And that's a line⏎)
              green_line %(+ Something completely different⏎)
              plain_line %(  And there's a line too)
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given completely different multi-line strings" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: "This is a line\nAnd that's a line\n",
          actual: "Something completely different\nAnd something else too\n"
        )

        expected_output = <<~STR.strip
          Differing strings.

          #{
            colored do
              red_line   %(Expected: "This is a line⏎And that's a line⏎")
              green_line %(  Actual: "Something completely different⏎And something else too⏎")
            end
          }

          Diff:

          #{
            colored do
              red_line   %(- This is a line⏎)
              red_line   %(- And that's a line⏎)
              green_line %(+ Something completely different⏎)
              green_line %(+ And something else too⏎)
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given the same array" do
      it "returns an empty string" do
        output = described_class.call(
          expected: ["sausage", "egg", "cheese"],
          actual: ["sausage", "egg", "cheese"]
        )

        expect(output).to eq("")
      end
    end

    context "given two equal-length, one-dimensional arrays with differing numbers" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: [1, 2, 3, 4],
          actual: [1, 2, 99, 4]
        )

        expected_output = <<~STR.strip
          Differing arrays.

          #{
            colored do
              red_line   %(Expected: [1, 2, 3, 4])
              green_line %(  Actual: [1, 2, 99, 4])
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  [)
              plain_line %(    1,)
              plain_line %(    2,)
              red_line   %(-   3,)
              green_line %(+   99,)
              plain_line %(    4)
              plain_line %(  ])
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-length, one-dimensional arrays with differing symbols" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: [:one, :fish, :two, :fish],
          actual: [:one, :FISH, :two, :fish]
        )

        expected_output = <<~STR.strip
          Differing arrays.

          #{
            colored do
              red_line   %(Expected: [:one, :fish, :two, :fish])
              green_line %(  Actual: [:one, :FISH, :two, :fish])
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  [)
              plain_line %(    :one,)
              red_line   %(-   :fish,)
              green_line %(+   :FISH,)
              plain_line %(    :two,)
              plain_line %(    :fish)
              plain_line %(  ])
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-length, one-dimensional arrays with differing strings" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: ["sausage", "egg", "cheese"],
          actual: ["bacon", "egg", "cheese"]
        )

        expected_output = <<~STR.strip
          Differing arrays.

          #{
            colored do
              red_line   %(Expected: ["sausage", "egg", "cheese"])
              green_line %(  Actual: ["bacon", "egg", "cheese"])
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  [)
              red_line   %(-   "sausage",)
              green_line %(+   "bacon",)
              plain_line %(    "egg",)
              plain_line %(    "cheese")
              plain_line %(  ])
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-length, one-dimensional arrays with differing objects" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: [
            SuperDiff::Test::Person.new(name: "Marty"),
            SuperDiff::Test::Person.new(name: "Jennifer")
          ],
          actual: [
            SuperDiff::Test::Person.new(name: "Marty"),
            SuperDiff::Test::Person.new(name: "Doc")
          ],
        )

        expected_output = <<~STR.strip
          Differing arrays.

          #{
            colored do
              red_line   %(Expected: [#<Person name="Marty">, #<Person name="Jennifer">])
              green_line %(  Actual: [#<Person name="Marty">, #<Person name="Doc">])
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  [)
              plain_line %(    #<Person {)
              plain_line %(      name="Marty")
              plain_line %(    }>,)
              red_line   %(-   #<Person {)
              red_line   %(-     name="Jennifer")
              red_line   %(-   }>)
              green_line %(+   #<Person {)
              green_line %(+     name="Doc")
              green_line %(+   }>)
              plain_line %(  ])
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two one-dimensional arrays where the actual has elements added to the end" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: ["bread"],
          actual: ["bread", "eggs", "milk"]
        )

        expected_output = <<~STR.strip
          Differing arrays.

          #{
            colored do
              red_line   %(Expected: ["bread"])
              green_line %(  Actual: ["bread", "eggs", "milk"])
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  [)
              plain_line %(    "bread",)
              green_line %(+   "eggs",)
              green_line %(+   "milk")
              plain_line %(  ])
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two one-dimensional arrays where the actual has elements missing from the end" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: ["bread", "eggs", "milk"],
          actual: ["bread"]
        )

        expected_output = <<~STR.strip
          Differing arrays.

          #{
            colored do
              red_line   %(Expected: ["bread", "eggs", "milk"])
              green_line %(  Actual: ["bread"])
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  [)
              plain_line %(    "bread")
              red_line   %(-   "eggs",)
              red_line   %(-   "milk")
              plain_line %(  ])
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two one-dimensional arrays where the actual has elements added to the beginning" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: ["milk"],
          actual: ["bread", "eggs", "milk"]
        )

        expected_output = <<~STR.strip
          Differing arrays.

          #{
            colored do
              red_line   %(Expected: ["milk"])
              green_line %(  Actual: ["bread", "eggs", "milk"])
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  [)
              green_line %(+   "bread",)
              green_line %(+   "eggs",)
              plain_line %(    "milk")
              plain_line %(  ])
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two one-dimensional arrays where the actual has elements removed from the beginning" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: ["bread", "eggs", "milk"],
          actual: ["milk"]
        )

        expected_output = <<~STR.strip
          Differing arrays.

          #{
            colored do
              red_line   %(Expected: ["bread", "eggs", "milk"])
              green_line %(  Actual: ["milk"])
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  [)
              red_line   %(-   "bread",)
              red_line   %(-   "eggs",)
              plain_line %(    "milk")
              plain_line %(  ])
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given the same hash" do
      it "returns an empty string" do
        output = described_class.call(
          expected: { name: "Marty" },
          actual: { name: "Marty" }
        )

        expect(output).to eq("")
      end
    end

    context "given two equal-size, one-dimensional hashes where the same key has differing numbers" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: { tall: 12, grande: 19, venti: 20 },
          actual: { tall: 12, grande: 16, venti: 20 }
        )

        expected_output = <<~STR.strip
          Differing hashes.

          #{
            colored do
              red_line   %(Expected: { tall: 12, grande: 19, venti: 20 })
              green_line %(  Actual: { tall: 12, grande: 16, venti: 20 })
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  {)
              plain_line %(    tall: 12,)
              red_line   %(-   grande: 19,)
              green_line %(+   grande: 16,)
              plain_line %(    venti: 20)
              plain_line %(  })
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-size, one-dimensional hashes where keys are strings and the same key has differing numbers" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: { "tall" => 12, "grande" => 19, "venti" => 20 },
          actual: { "tall" => 12, "grande" => 16, "venti" => 20 }
        )

        expected_output = <<~STR.strip
          Differing hashes.

          #{
            colored do
              red_line   %(Expected: { "tall" => 12, "grande" => 19, "venti" => 20 })
              green_line %(  Actual: { "tall" => 12, "grande" => 16, "venti" => 20 })
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  {)
              plain_line %(    "tall" => 12,)
              red_line   %(-   "grande" => 19,)
              green_line %(+   "grande" => 16,)
              plain_line %(    "venti" => 20)
              plain_line %(  })
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-size, one-dimensional hashes where the same key has differing symbols" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: { tall: :small, grande: :grand, venti: :large },
          actual: { tall: :small, grande: :medium, venti: :large },
        )

        expected_output = <<~STR.strip
          Differing hashes.

          #{
            colored do
              red_line   %(Expected: { tall: :small, grande: :grand, venti: :large })
              green_line %(  Actual: { tall: :small, grande: :medium, venti: :large })
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  {)
              plain_line %(    tall: :small,)
              red_line   %(-   grande: :grand,)
              green_line %(+   grande: :medium,)
              plain_line %(    venti: :large)
              plain_line %(  })
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-size, one-dimensional hashes where the same key has differing strings" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: { tall: "small", grande: "grand", venti: "large" },
          actual: { tall: "small", grande: "medium", venti: "large" }
        )

        expected_output = <<~STR.strip
          Differing hashes.

          #{
            colored do
              red_line   %(Expected: { tall: "small", grande: "grand", venti: "large" })
              green_line %(  Actual: { tall: "small", grande: "medium", venti: "large" })
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  {)
              plain_line %(    tall: "small",)
              red_line   %(-   grande: "grand",)
              green_line %(+   grande: "medium",)
              plain_line %(    venti: "large")
              plain_line %(  })
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-size, one-dimensional hashes where the same key has differing objects" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: {
            steve: SuperDiff::Test::Person.new(name: "Jobs"),
            susan: SuperDiff::Test::Person.new(name: "Kare")
          },
          actual: {
            steve: SuperDiff::Test::Person.new(name: "Wozniak"),
            susan: SuperDiff::Test::Person.new(name: "Kare")
          }
        )

        # TODO: This should look inside each object and diff it
        expected_output = <<~STR.strip
          Differing hashes.

          #{
            colored do
              red_line   %(Expected: { steve: #<Person name="Jobs">, susan: #<Person name="Kare"> })
              green_line %(  Actual: { steve: #<Person name="Wozniak">, susan: #<Person name="Kare"> })
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  {)
              red_line   %(-   steve: #<Person {)
              red_line   %(-     name="Jobs")
              red_line   %(-   }>,)
              green_line %(+   steve: #<Person {)
              green_line %(+     name="Wozniak")
              green_line %(+   }>,)
              plain_line %(    susan: #<Person {)
              plain_line %(      name="Kare")
              plain_line %(    }>)
              plain_line %(  })
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-size, one-dimensional hashes where the actual has extra keys" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: { latte: 4.5 },
          actual: { latte: 4.5, mocha: 3.5, cortado: 3 }
        )

        expected_output = <<~STR.strip
          Differing hashes.

          #{
            colored do
              red_line   %(Expected: { latte: 4.5 })
              green_line %(  Actual: { latte: 4.5, mocha: 3.5, cortado: 3 })
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  {)
              plain_line %(    latte: 4.5,)
              green_line %(+   mocha: 3.5,)
              green_line %(+   cortado: 3)
              plain_line %(  })
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two equal-size, one-dimensional hashes where the actual has missing keys" do
      it "returns a message along with the diff" do
        actual_output = described_class.call(
          expected: { latte: 4.5, mocha: 3.5, cortado: 3 },
          actual: { latte: 4.5 }
        )

        expected_output = <<~STR.strip
          Differing hashes.

          #{
            colored do
              red_line   %(Expected: { latte: 4.5, mocha: 3.5, cortado: 3 })
              green_line %(  Actual: { latte: 4.5 })
            end
          }

          Diff:

          #{
            colored do
              plain_line %(  {)
              plain_line %(    latte: 4.5)
              red_line   %(-   mocha: 3.5,)
              red_line   %(-   cortado: 3)
              plain_line %(  })
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end

    context "given two objects which == each other" do
      it "returns an empty string" do
        expected = SuperDiff::Test::Person.new(name: "Marty")
        actual = SuperDiff::Test::Person.new(name: "Marty")

        output = described_class.call(expected: expected, actual: actual)

        expect(output).to eq("")
      end
    end

    context "given two objects which do not == each other" do
      it "returns a message along with a comparison" do
        expected = SuperDiff::Test::Person.new(name: "Marty")
        actual = SuperDiff::Test::Person.new(name: "Doc")

        actual_output = described_class.call(expected: expected, actual: actual)

        expected_output = <<~STR.strip
          Differing objects.

          #{
            colored do
              red_line   %(Expected: #<Person name="Marty">)
              green_line %(  Actual: #<Person name="Doc">)
            end
          }
        STR

        expect(actual_output).to eq(expected_output)
      end
    end
  end

  def colored(&block)
    SuperDiff::Tests::Colorizer.call(&block).chomp
  end
end
