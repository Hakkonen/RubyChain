# Runs node and mines blocks adding data from mempool to the blockchain

require "./node/mine"
require "./node/block"
require "./node/blockchain"
require "./utils/verify"
require "./utils/loop"
require "./utils/tx"

require "sinatra"
require 'active_support/time'

require "pp"

# Creates cached chain
BLOCKCHAIN = Blockchain.new([])
# Loads JSON into cache
BLOCKCHAIN.ledger["mainnet"] = Mine.read_ledger()
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
    count = 5
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
    from, to, amount = params.values_at("from", "to", "amount")
    new_tx = Tx.new(from, to, amount)
    puts new_tx

    # TODO: Run an asymmetric signature check on sender's Tx

    # TODO: Run verify on blockchain to validate that funds are available
    # Will need to parse the chain and add up all calculations from send address

    # Read mempool JSON into cache
    mempool_cache = Mine.read_mempool()

    # TODO: Checksum against account balances

    # Append tx to mempool cache
    mempool_cache << new_tx

    puts "Mempool read:"
    pp mempool_cache

    # Write mempool to JSON
    Mine.write_mempool(mempool_cache)
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