# Runs mining operation

require "./node/block"
require "./node/blockchain.rb"

require "json"
require "digest"
require "pp"

def mempool_loader(address="./mempool_dir/mempool.txt")
    # Opens mempool from given address and returns text file to var

    mempool_load = nil
    File.open(address, "r+") do |f|
        # Reads mempool data
        mempool_load = f.read()

        # Empties mempool after load, so transactions aren't duplicated
        f.truncate(0)
    end
    puts "MEMPOOL LOADED:"
    puts mempool_load

    return mempool_load
end


module Mine
    # Runs mining operations
    def Mine.run(chain)

        # Open mempool data
        mempool = mempool_loader()

        # Mine block
        # Ingests mempool data, it's merkle root and prior hash
        if chain.ledger["mainnet"].any?
            # Creates new Block from cache and appends to chain ledger
            chain.ledger["mainnet"] << Block.new(chain.ledger["mainnet"][-1].hash, Digest::SHA256.hexdigest(rand(8).to_s), mempool.to_s, chain.ledger["mainnet"][-1].id.to_s)
        else
            # Creates new genesis Block and appends to chain ledger 
            chain.ledger["mainnet"] << Block.new("00000000", "00000000", mempool.to_s, "0")
        end

        # Write block to ledger backup
        Mine.write_ledger(chain.ledger["mainnet"])

        return chain
    end

    # Reads ledger
    def Mine.read_ledger(address="./ledger/ledger.json")
        # If file is empty, ask to make first block
        if File.zero?(address) 
            puts "No ledger data found, create genesis block?"
            ledger_hash = []
        else
        # Else ingest file JSON data
            file = File.read(address)
            ledger_hash = JSON.parse(file)
        end

        # Converts JSON file to array of objects
        objectify = []
        ledger_hash.each do |block|
            objectify << Block.json_create(block)
        end

        # Return JSON parsed ledger
        return objectify
    end

    # Writes to ledger
    def Mine.write_ledger(ledger, address="./ledger/ledger.json")
        # Open ledger.json
        File.open(address, "w+") do |file|
            # Write JSON blockchain data to file
            file.write(ledger.to_json)
        end
    end
end