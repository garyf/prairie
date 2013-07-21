RSpec.configure do |config|
  # allow use of :redis rather than redis: true; will no longer be necessary in RSpec 3
  # www.relishapp.com/rspec/rspec-core/v/2-14/docs/hooks/filters#use-symbols-as-metadata
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:each, :redis) { Redis.current.flushall }
end
