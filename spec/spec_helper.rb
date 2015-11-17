$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_repository_record_mapper'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
