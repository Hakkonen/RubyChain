# This is the blockchain class

class Blockchain
    attr_accessor :ledger

    def initialize()
        # Takes in an array of blocks
        @ledger = []
    end

    def add_block(block)
        @ledger << block.to_json
        # puts @ledger
    end

    def ledger()
        return @ledger
    end

    # def output()
    #     output = {}

    # end
end