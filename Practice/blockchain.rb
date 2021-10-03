require "json"

module Blockchain
    # MEMPOOL READ/WRITE
    # Writes mempool data
    def Blockchain.write_mempool(mempool_file, data)
        puts "Data: " + data.to_s
        File.open(mempool_file, "w+") do |line|
            line.write(data)
        end
        puts "End write"
    end

    # Reads mempool data
    def Blockchain.read_mempool(mempool_file)
        # Reads transactions from mempool and inputs to block mine func
        mempool = []
        File.readlines(mempool_file).map do |line|
            #mempool.push line.split.map().to_s
            mempool = line
        end

        # Empties mempool file
        File.open(mempool_file, "w+").truncate(0)
        
        return mempool
    end

    # TODO: Fix writing JSON to ledger
    ######  Will need to be turned into array and written?
    # LEDGER READ/WRITE
    # Writes ledger blocks
    def Blockchain.write_ledger(ledger_addr, mempool_addr)
        # Write block to ledger
        File.open(ledger_addr, "w") do |line|
            line.write(new_block.to_json)
        end
    end

    def Blockchain.read_ledger(ledger_addr)
        if (File.zero?(ledger_addr) == true)
            hash = []
            return hash
        else
            json_from_file = File.read(ledger_addr)
            hash = JSON.parse(json_from_file)
            return hash
        end
    end

    # MINING
    # Mines blocks
    def Blockchain.mine(blockchain, mempool_addr)
        # Extract mempool data
        random_data = [rand(10000).to_s, rand(10000).to_s]
        # Write temp mempool data
        Blockchain.write_mempool(mempool_addr, random_data)
        # Read mempool data for block mine
        mempool_data = Array(Blockchain.read_mempool(mempool_addr))

        # Begin block mine
        if (blockchain.length < 1)
            puts "GENESIS BLOCK"
            new_block = Block.new("00000000", rand(5000).to_s, mempool_data, "0000")
            pp new_block
        else
            new_block = Block.new(blockchain[-1].hash.to_s, rand(5000).to_s, mempool_data, "0000")
        end

        # pp new_block

        return new_block
    end
end