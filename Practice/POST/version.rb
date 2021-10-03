#!/usr/bin/ruby

require "faraday"

# Gets version info
# puts Faraday::VERSION
# puts Faraday::default_adapter

res = Faraday.get "http://localhost:4567/"

puts res.body