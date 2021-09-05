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

        puts "LOADED LAST BLOCK:"
        puts chain.ledger["mainnet"][-1]

        # Load last block into object
        last_block = Block.json_create(chain.ledger["mainnet"][-1])
        puts "LAST BLOCK:"
        pp last_block
        puts last_block.hash

        # Mine block
        # Ingests mempool data, it's merkle root and prior hash
        new_block = nil
        if chain.ledger["mainnet"].any?
            puts "Previous hash:"
            puts last_block.hash
            chain.ledger["mainnet"] << Block.new(last_block.hash, Digest::SHA256.hexdigest(rand(8).to_s), mempool.to_s)
        else
            chain.ledger["mainnet"] << Block.new("00000000", Digest::SHA256.hexdigest(rand(8).to_s), mempool.to_s)
        end

        puts "New block:"
        pp chain.ledger["mainnet"][-1]

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
            puts "LEDGER HASH"
            pp ledger_hash
        end

        # Convert json to array
        

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