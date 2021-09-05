# This is the blockchain class

class Blockchain
    attr_accessor :ledger

    def initialize(ledger_arr)
        # Takes in an array of blocks
        @ledger = {
            "mainnet" => ledger_arr
        }
    end

    def add_block(block)
        @ledger["mainnet"] << block.to_json
    end

    def to_json(*args)
        {
        JSON.create_id => self.class.name,
            "ledger" => ledger
        }.to_json(*args)
    end

    def self.json_create(h)
        new(h["ledger"])
    end
end