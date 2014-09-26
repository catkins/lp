require 'coding_exercise'
require 'pry'
require 'nokogiri'

RSpec.configure do |config|

  # force the newer expect syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

end

