# Runs mining operation

require "./node/block"
require "./node/blockchain.rb"

require "json"
require "pp"


module Mine
    # Runs mining operations
    def Mine.run()
        # Open blockchain cache
        blockchain = Blockchain.new()

        # Open ledger to cache
        ledger_cache = Mine.read_ledger()

        # Mine test block
        block = Block.new(rand(8).to_s, rand(8).to_s, "315ndvwi7data8731")
        blockchain.add_block(block)
        
        # Write block to ledger
        Mine.write_ledger(blockchain.ledger)
    end

    # Reads ledger
    def Mine.read_ledger(address="./ledger/ledger.json")
        if File.zero?(address) 
            puts "No ledger data found, create genesis block?"
        else
            file = File.read(address)
            ledger_hash = JSON.parse(file)
        end

        return ledger_hash
    end

    # Writes to ledger
    def Mine.write_ledger(ledger_output, address="./ledger/ledger.json")
        File.open(address, "w+") do |f|
            f.write(ledger_output.to_json)
        end
    end
end