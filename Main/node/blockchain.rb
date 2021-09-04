# This is the blockchain class

class Blockchain
    attr_accessor :ledger

    def initialize()
        # Takes in an array of blocks
        @ledger = {
            "mainnet" => []
        }
    end

    def add_block(block)
        @ledger["mainnet"] << block.to_json
    end
end