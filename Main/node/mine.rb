# Runs mining operation

require "./node/block"
require "./node/blockchain"
require "./utils/tx"
require "./utils/JsonIO.rb"   # Imports read write func for JSON data

require "json"
require "digest"
require "pp"

module Mine

    $master_privkey, $master_pubkey = KeyChain.keypair_gen("master")
    $master_pub_address = KeyChain.public_address_gen($master_pubkey)
    
    # Runs mining operations
    def Mine.run(chain, address, difficulty="000000")

        # Open mempool data
        # mempool = JsonIO.read("./mempool_dir/mempool.json", Tx)
        mempool = File.read("./mempool_dir/mempool.json")

        # TODO: Create address that gives rewards from limited pool
        # Add miner's reward
        # Create signature
        reward_string = $master_pub_address.to_s + "," + address.to_s + "," + "1"
        reward_signature = KeyChain.sign($master_privkey, reward_string).unpack('H*') # Unpack hex string
        KeyChain.verify($master_pubkey, reward_signature.pack('H*'), reward_string) # Pack hex string
        
        reward = Tx.new($master_pub_address[0], address.to_s, "1", reward_signature[0])

        reward_hash = reward.to_json

        ## TODO: Need to make it go in as an array
        mempool << reward_hash.to_s

        pp mempool

        # Clear mempool to not reuse Tx's
        Mine.clear_mempool()

        # Mine block
        # Ingests mempool data, it's merkle root and prior hash
        if chain.ledger["mainnet"].any?
            # Creates new Block from cache and appends to chain ledger
            chain.ledger["mainnet"] << Block.new(chain.ledger["mainnet"][-1].hash, Digest::SHA256.hexdigest(rand(8).to_s), mempool.to_s, chain.ledger["mainnet"][-1].id.to_s)
        else
            # Creates new genesis Block and appends to chain ledger 
            chain.ledger["mainnet"] << Block.new("00000000", "00000000", mempool.to_s, "0", difficulty)
        end

        # Write block to ledger backup
        JsonIO.write("./ledger/ledger.json", chain.ledger["mainnet"])

        return chain
    end

    def Mine.create_tx(from, to, amount)
        Tx.new(from, to, amount)
    end

    def Mine.clear_mempool(address="./mempool_dir/mempool.json")
        File.open(address, "w+") do |file|
            file.truncate(0)
        end
    end
end