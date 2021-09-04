# Runs mining operation

require "./node/block"
require "./node/blockchain.rb"

require "json"
require "csv"
require "pp"


module Mine
    # Runs mining operations
    def Mine.run()
        # Open blockchain cache
        blockchain = Blockchain.new()
        blockchain.ledger["data"] = Mine.read_ledger()

        # Open ledger to cache
        puts "Printing loaded ledger:"
        # pp blockchain.ledger

        # # Mine test block
        # block = Block.new(rand(8).to_s, rand(8).to_s, "315ndvwi7data8731")
        # block2 = Block.new(rand(8).to_s, rand(8).to_s, "121DATvwi7data8731")
        # # Add block to blockchain
        # blockchain.add_block(block)
        # blockchain.add_block(block2)
        # Print test blocks
        puts "With test blocks:"
        puts blockchain.ledger["data"][0]
        puts "NEXT"
        puts blockchain.ledger["data"][1]
        
        # new_block = Block.new(blockchain.ledger[-1].hash)
        
        # Write block to ledger
        # Mine.write_ledger(blockchain.ledger["data"])
    end

    # Reads ledger
    def Mine.read_ledger(address="./ledger/ledger.json")
        # If file is empty, ask to make first block
        if File.zero?(address) 
            puts "No ledger data found, create genesis block?"
        else
        # Else ingest file JSON data
            file = File.read(address)
            ledger_hash = JSON.parse(file)
        end

        # Return JSON parsed ledger
        return ledger_hash
    end

    # Writes to ledger
    def Mine.write_ledger(ledger, address="./ledger/ledger.json")
        # Open text file
        # Open ledger.json
        File.open(address, "w+") do |file|
            # Write JSON blockchain data to file
            file.write(ledger.to_json)
        end
    end
end