require 'rspec/collection_matchers'
require 'simplecov'
require 'pry'
require 'fakefs/safe'
require 'fakefs/spec_helpers'
require 'nokogiri'

if ENV['COVERAGE']
  SimpleCov.start do
     add_filter '/spec/'
     add_group 'Models', 'models'
     add_group 'Helpers', 'helpers'
     add_group 'Parsers', 'parser'
  end
end

require 'coding_exercise'

RSpec.configure do |config|

  # force the newer expect syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

end

