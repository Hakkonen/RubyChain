# operates the blockchain

# How to require an external class 
# require_relative "test_block"

require_relative "blockchain"
require_relative "block"

def main()
    # How to import class below
    # genesis = Block.new
    
    # p genesis
    # genesis.test()
    # -------------------------

    # 1. Generate blockchain array
    ruby_chain = Blockchain.new

    # 2. Initalise genesis block
    genesis_block = Block.new

    p genesis_block
end

main()