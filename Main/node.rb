# Runs node and mines blocks adding data from mempool to the blockchain

require "./node/mine"
require "./wallet"
require "./node/block"
require "./node/blockchain.rb"
require "./utils/verify.rb"

require "pp"

# Load Ledger
def load_ledger(input_chain)
    input_chain.ledger["mainnet"] = Mine.read_ledger()

    # Prints loaded blockchain
    puts "Blockchain loaded"
    # pp input_chain
    puts ""

    menu()
end

# Verify Ledger
def ver_ledger(input_chain)
    Verify.chain(input_chain)
end

# Mine blocks
def mine_blocks(input_chain)
    input_chain = Mine.run(input_chain)

    menu()
end

# View blocks
def view_chain(input_chain)
    # Print blocks
    counter = 1
    input_chain.ledger["mainnet"].each do |block|
        puts "BLOCK " + counter.to_s
        pp block
        counter += 1
    end

    menu()
end

# Close node
def close_node(chain, address="./ledger/ledger.json")
    file = File.read(address)
    ledger_hash = JSON.parse(file)
    pp ledger_hash
end

# Welcome menu
def menu()
    puts "Welcome to RubyChain", "Menu:", "1. Load blockchain from file", "2. Verify ledger", "3. Mine blocks", "4. View chain", "5. Close node"
    selection = gets.chomp()
    if selection == "1"
        load_ledger(@blockchain)
        menu()
    elsif selection == "2"
        ver_ledger(@blockchain)
    elsif selection == "3"
        mine_blocks(@blockchain)
    elsif selection == "4"
        view_chain(@blockchain)
    elsif selection == "5"
        close_node(@blockchain)
    end
    exit
end

def main() 
    # Load blockchain cache from class
    @blockchain = Blockchain.new([])

    menu()
end

main()