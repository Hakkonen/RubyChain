# This is the blockchain class

class Blockchain
    attr_accessor :ledger

    def initialize()
        # Takes in an array of blocks
        @ledger = {
            "data" => []
        }
    end

    def add_block(block)
        @ledger["data"] << block.to_json
        # puts @ledger
    end

    def marshal_dump
        [@ledger]
    end

    def marshal_load array
        @ledger = array
    end

    # def ledger()
    #     return @ledger
    # end
end