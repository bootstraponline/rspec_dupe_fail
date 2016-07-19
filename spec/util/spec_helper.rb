require 'rubygems'
require 'bundler/setup'
require 'rspec'

require_relative '../util/sauce_rspec'

# Comment out broken_patch and uncomment working_patch to see the tests pass.
# require_relative '../patch/working_patch'

# Broken patch uses the dupe API and rspec-core crashes with:
#
# 1) dupe should add caps to each test
# Failure/Error: @example_group_instance.instance_exec(self, &@example_block)
#
# LocalJumpError:
#     no block given
# gems/rspec-core-3.5.1/lib/rspec/core/example.rb:252:in `instance_exec'
#
# @example_block in example.rb is nil.
#
require_relative '../patch/broken_patch'

RSpec.configure do |configure|
  configure.after(:each) do
    example = RSpec.current_example
    caps_method = example.respond_to?(:caps)
    caps = caps_method ? example.caps : example.metadata[:caps]

    fail 'Example has no caps' unless caps
    $stdout.puts "caps: #{caps}"
  end
end
