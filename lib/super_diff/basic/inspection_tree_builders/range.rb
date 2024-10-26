module SuperDiff
  module Basic
    module InspectionTreeBuilders
      class Range < Core::AbstractInspectionTreeBuilder
        def self.applies_to?(value)
          value.is_a?(::Range)
        end

        def call
          Core::InspectionTree.new do |t1|
            t1.add_text object.inspect
          end
        end
      end
    end
  end
end
