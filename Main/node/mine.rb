# Runs mining operation

require "./node/block"
require "./node/blockchain"
require "./utils/tx"

require "json"
require "digest"
require "pp"

# TODO: Condense code! Possible combine read/write funcs into one?

module Mine
    
    # Runs mining operations
    def Mine.run(chain, address)

        # Open mempool data
        # mempool = [] 
        mempool = Mine.read_mempool()

        # Clear mempool to not reuse Tx's
        Mine.clear_mempool()

        # TODO: Create address that gives rewards from limited pool
        # Add miner's reward
        puts "Mempool is:"
        pp mempool
        puts "Mempool plus address is:"
        mempool << Tx.new("MASTER", address.to_s, "1")
        pp mempool

        # Mine block
        # Ingests mempool data, it's merkle root and prior hash
        if chain.ledger["mainnet"].any?
            # Creates new Block from cache and appends to chain ledger
            chain.ledger["mainnet"] << Block.new(chain.ledger["mainnet"][-1].hash, Digest::SHA256.hexdigest(rand(8).to_s), mempool.to_s, chain.ledger["mainnet"][-1].id.to_s)
        else
            # Creates new genesis Block and appends to chain ledger 
            chain.ledger["mainnet"] << Block.new("00000000", "00000000", mempool.to_s, "0")
        end

        puts chain.ledger["mainnet"][-1].hash

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

    # Reads mempool JSON into cache array
    def Mine.read_mempool(address="./mempool_dir/mempool.json")
        mempool_cache = []
        # Open mempool into cache
        if File.zero?(address) 
            puts "No mempool data"
            return mempool_cache
        else
            file = File.read(address)
            mempool_res = JSON.parse(file)

            mempool_res.each do |e|
                puts "ELEMENT"
                pp e
                mempool_cache << Tx.json_create(e)
            end
        end
        return mempool_cache
    end

    # Writes cached mempool into JSON file
    def Mine.write_mempool(mempool, address="./mempool_dir/mempool.json")
        # Save mempool into file
        File.open(address, "w+") do |file|
            # Write JSON blockchain data to file
            file.write(mempool.to_json)
        end
    end

    def Mine.create_tx(from, to, amount)
        Tx.new(from, to, amount)
    end

    def Mine.clear_mempool(address="./mempool_dir/mempool.json")
        File.open(address, "w+") do |file|
            file.truncate(0)
            puts "Mempool cleared..."
        end
    end
end