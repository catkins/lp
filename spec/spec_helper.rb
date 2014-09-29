require 'rspec/collection_matchers'
require 'rspec/its'
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

  # https://github.com/erikhuda/thor/blob/81dadf41b1d0422d1be1a7b2655603b47e8ff46a/spec/helper.rb#L48
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end

