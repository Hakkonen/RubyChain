# Runs mining funcs

require "./node/mine"
require "./node/block"
require "./node/blockchain"
require "./utils/verify"
require "./utils/loop"
require "./utils/tx"
require "./utils/JsonIO.rb"   # Imports read write func for JSON data

# require "sinatra"
require 'active_support/time'

require "json"
require "pp"

## TODO: Verify chain on load

# Creates cached chain
$blockchain = Blockchain.new([])
def get_chain()
    # Loads JSON into cache
    # BLOCKCHAIN.ledger["mainnet"] = Mine.read_ledger()
    $blockchain.ledger["mainnet"] = JsonIO.read("./ledger/ledger.json", Block)
    puts "Blockchain loaded"
end
get_chain()

## DEFINE ADDRESS GLOBAL
$address = ""

# Select to load from saved key or enter new key
puts "Enter PubKey for mining rewards:"
puts "1. Load saved key"
puts "2. Enter new key"
selection = gets.chomp()

# Read / write key funcs
# Loads key from default address
def read_key(address="./node/keyphrase.txt")
    if File.zero?(address)
        puts "No read data found"
        return false
    else
        file = File.read(address).to_s
        return file
    end
end
# Writes key to default address
def write_key(data, address="./node/keyphrase.txt")
    File.open(address, "w") do |file|
        file.write(data)
    end
end

if selection == "1"
    $address = read_key()
elsif selection == "2"
    puts "Please enter your RubyChain address for mining rewards:"
    $address = gets.chomp()

    # Save key?
    puts "Overwrite saved key? (Y/n):"
    selection = gets.chomp()
    if selection == "y" || selection == "Y"
        # Save key
        write_key($address)
    end
end

# Mining func
# Mine blocks
def mine_blocks(input_chain, addr, difficulty="000000")
    input_chain = Mine.run(input_chain, addr, difficulty)
end

## Mining Menu
puts "Load mode:"
puts "1. Test server"
puts "2. Live server"
mine_mode = gets.chomp()
while mine_mode == "1" || mine_mode == "2"
    if mine_mode == "1"
        # while true
        # Ask to mine new block
        puts ""
        puts "Mine block? (Y/n)"
        selection = gets.chomp()
        if selection == "Y" || selection == "y"
            # Mine block if true
            puts "Test mining"
            get_chain()
            mine_blocks($blockchain, $address, "00")
            "Block mined"
        elsif selection == "n" || selection == "N"
            run_mine = false
            break
        end
        # end
    elsif mine_mode == "2"
        # Live mine
        # Auto mine
        puts "Live mining"
        get_chain()
        mine_blocks($blockchain, $address, "00")
        "Block mined"
    end
end


# # Repeats a task infinitely 
# Currently just showing that server is running
# Loop.repeat_every(3.seconds) do
#     puts "Miner running @ " + Time.now
# end
