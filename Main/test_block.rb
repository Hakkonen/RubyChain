require 'time'

class Block
    def initialize()
        @data = "1000BTC"
        @prev_hash = "00000000000"
        @hash = "3152hbt4iuy4n98"
        @timestamp = Time.now.to_i
    end
end
