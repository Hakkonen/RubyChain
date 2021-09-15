# Runs mining operation

require "./node/block"
require "./node/blockchain"
require "./utils/tx"
require "./utils/JsonIO.rb"   # Imports read write func for JSON data

require "json"
require "digest"
require "pp"

module Mine
    
    # Runs mining operations
    def Mine.run(chain, address)

        # Open mempool data
        # mempool = JsonIO.read("./mempool_dir/mempool.json", Tx)
        mempool = File.read("./mempool_dir/mempool.json")

        puts "mempool: "
        pp mempool

        # TODO: Create address that gives rewards from limited pool
        # Add miner's reward
        # mempool << Tx.new("MASTER", address.to_s, "1", )

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
        JsonIO.write("./ledger/ledger.json", chain.ledger["mainnet"])

        # Clear mempool to not reuse Tx's
        Mine.clear_mempool()

        return chain
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