require 'awscosts'
require 'vcr'

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :fakeweb
end



