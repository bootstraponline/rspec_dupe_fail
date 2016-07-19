module RSpec
  module Core
    class World
      alias_method :rspec_record, :record

      # @api private
      #
      # Records an example group.
      def record(example_group)
        # Use upstream record method if we're not configured to run on Sauce
        config = ::SauceRSpec.config
        return rspec_record(example_group) unless config.sauce?

        # Must iterate through descendants to handle nested describes
        example_group.descendants.each do |desc_group|

          # clone to avoid infinite loop.
          # duplicate_with will add an example to the array we're iterating over.
          desc_group.examples.clone.each do |ex|
            config.caps.each do |cap|
              ex.duplicate_with(caps: cap)
            end

            # remove example without caps
            desc_group.remove_example ex
          end

        end

        # invoke original record method
        rspec_record(example_group)
      end
    end
  end
end unless RSpec::Core::World.method_defined? :rspec_record
