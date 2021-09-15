# Runs node and mines blocks adding data from mempool to the blockchain

require "./node/mine"
require "./node/block"
require "./node/blockchain"
require "./utils/verify"
require "./utils/loop"
require "./utils/tx"
require "./utils/JsonIO.rb"   # Imports read write func for JSON data

require "sinatra"
require 'active_support/time'

require "json"
require "pp"

# Creates cached chain
BLOCKCHAIN = Blockchain.new([])
# Loads JSON into cache
# BLOCKCHAIN.ledger["mainnet"] = Mine.read_ledger()
BLOCKCHAIN.ledger["mainnet"] = JsonIO.read("./ledger/ledger.json", Block)
puts "Blockchain loaded"

puts "Please enter your RubyChain address for mining rewards:"
ADDRESS = gets.chomp()

get "/" do
    "Root"
end

# Prints verification of block
get "/verify" do
    ver_ledger(BLOCKCHAIN)
end

# Mines a block on access
get "/mine" do
    count = 1
    while count > 0
        "Mining"
        mine_blocks(BLOCKCHAIN, ADDRESS)
        "Block mined"
        count -= 1
    end
end

# Receives Tx details from wallet and adds to mempool
post "/transaction" do
    # Init mempool cache
    mempool_cache = []

    # Create new tx object
    from, to, amount, signature = params.values_at("from", "to", "amount", "signature")
    new_tx = Tx.new(from, to, amount, signature)
    puts new_tx

    # TODO: Run an asymmetric signature check on sender's Tx
    # Decrypt signature with public key?
    # 1. Parse JSON ledger for BTC to spend
    # 2. Confirm blockchain hashes have not been modified
    #   to ensure that teh ledger has not been tampered with.

    # TODO: Run verify on blockchain to validate that funds are available
    # Will need to parse the chain and add up all calculations from send address

    # Read mempool JSON into cache
    mempool_cache = JsonIO.read("./mempool_dir/mempool.json", Tx)

    # TODO: Checksum against account balances

    # Append tx to mempool cache
    mempool_cache << new_tx

    puts "Mempool read:"
    pp mempool_cache

    # Write mempool to JSON
    # Mine.write_mempool(mempool_cache)
    JsonIO.write("./mempool_dir/mempool.json", mempool_cache)
end

get "/balance" do
    # Receives bitcoin address, parses database, and returns list of relevant tx's
    address = params.values_at("address")[0][0]
    puts "Address: " + address.to_s

    # Open transaction list for return
    tx_list = []
    balance = 0
    
    # Open blockchain JSON to search
    blockchain = JsonIO.read("./ledger/ledger.json", Block)
    blockchain.each do |block|
        # Parses string into JSON to allow iteration
        parsed_data = JSON.parse(block.data)
        # Unapcks each JSON object
        parsed_data.each do |tx|
            # Reforms Tx object from data
            tx_cache = Tx.json_create tx
            # Checks if transaction contains address
            if tx_cache.receiver == address
                tx_list << tx_cache
                balance += tx_cache.amount.to_i
            end
        end
    end

    puts "tx list:"
    pp tx_list

    # Prints object to page / returns value to program
    "#{balance}"
end

# TODO: View Blockchain
# Should return JSON for web viewer?
# get "/view" do
#     view_chain(BLOCKCHAIN)
# end

# Repeats a task infinitely 
# Currently just showing that server is running
Loop.repeat_every(30.seconds) do
    puts Time.now
end

# This has been automated at server start
# # Load Ledger
# def load_ledger(input_chain)
#     input_chain.ledger["mainnet"] = Mine.read_ledger()

#     # Prints loaded blockchain
#     puts ""
#     puts "Blockchain loaded to cache"
#     puts ""

#     menu()
# end

# Verify Ledger
def ver_ledger(input_chain)
    Verify.chain(input_chain)
end

# Mine blocks
def mine_blocks(input_chain, addr)
    input_chain = Mine.run(input_chain, addr)
end

# View blocks
def view_chain(input_chain)
    # Print blocks
    counter = 1
    input_chain.ledger["mainnet"].each do |block|
        "BLOCK " + counter.to_s
        pp block
        counter += 1
    end
end

# # Close node
# def close_node(chain, address="./ledger/ledger.json")
#     puts "Exiting..."
#     file = File.read(address)
#     ledger_hash = JSON.parse(file)
# end

# # Welcome menu
# def menu()
#     puts "Welcome to RubyChain", "Menu:", "1. Start node", "2. Verify ledger", "3. Mine blocks", "4. View chain", "5. Close node"
#     selection = gets.chomp()
#     if selection == "1"
#         load_ledger(@blockchain)
#     elsif selection == "2"
#         ver_ledger(@blockchain)
#     elsif selection == "3"
#         mine_blocks(@blockchain)
#     elsif selection == "4"
#         view_chain(@blockchain)
#     elsif selection == "5"
#         close_node(@blockchain)
#     end
#     exit
# end

# def main() 
#     # Cretes blockchain cache
#     @blockchain = Blockchain.new([])

#     menu()
# end

# main()