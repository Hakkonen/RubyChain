# Runs mining operation

require "./node/block"
require "./node/blockchain.rb"

require "json"
require "digest"
require "pp"


module Mine
    # Runs mining operations
    def Mine.run(chain)

        # Open mempool data
        mempool = ""
        File.open("./mempool_dir/mempool.txt", "r") do |f|
            mempool = f.read()
        end
        puts "MEMPOOL LOADED:"
        puts mempool

        # Mine block
        # Ingests mempool data, it's merkle root and prior hash
        new_block = nil
        if chain.any?
            chain << Block.new(chain[-1].to_s, Digest::SHA256.hexdigest(rand(8).to_s), mempool.to_s)
        else
            chain << Block.new("00000000", Digest::SHA256.hexdigest(rand(8).to_s), mempool.to_s)
        end

        puts "New block:"
        pp chain[-1]

        # Write block to ledger backup
        Mine.write_ledger(chain)

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