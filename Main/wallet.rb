# Creates, views, and updates address transactions and balances.

require "./node/mine"
require "./node/block"
require "./node/blockchain"
require "./utils/verify"
require "./utils/loop"
require "./utils/tx"
require "./utils/JsonIO.rb"   # Imports read write func for JSON data

require "json"
require "./wallet/keychain"

## Why even use a sinatra node?
## TODO: Just run wallet as a stand-alone balance and tx app

## TODO
# 1. Add check balance
# 2. Add send money

$private_key = ""
$public_key = ""
$pub_address = ""

# Keyphrase read / write function
def write_key(data, address="./wallet/keyphrase.txt")
    File.open(address, "w") do |file|
        file.write(data)
    end
end

# Loads key from default address
def read_key(address="./wallet/keyphrase.txt")
    if File.zero?(address)
        puts "No read data found"
        return false
    else
        file = File.read(address).to_s
        return file
    end
end

# Gets account balance
# def get_balance(address)
#     # Sends address to server
#     res = Faraday.get("#{URL}:#{PORT}/balance", address: address).body
#     # Returns response
#     puts "BALANCE: " + res + " RBC"
# end

def get_balance(address)
    # Receives bitcoin address, parses database, and returns list of relevant tx's
    # address = params.values_at("address")[0][0]
    puts "Address: " + address.to_s

    # Open transaction list for return
    tx_list = []
    balance = 0
    
    # Open blockchain JSON to search
    blockchain = JsonIO.read("./ledger/ledger.json", Block)
    blockchain.each do |block|
        if block.data != ""
            # Parses string into JSON to allow iteration
            parsed_data = JSON.parse(block.data)
            # Unpacks each JSON object
            parsed_data.each do |tx|
                # Reforms Tx object from data
                tx_cache = Tx.json_create tx
                # Checks if transaction contains address
                if tx_cache.receiver == address
                    # tx_list << tx_cache
                    balance += tx_cache.amount.to_i
                end
            end
        end
    end

    puts "tx list:"
    pp "BALANCE: " + balance.to_s + " RBC"
end

def send_tx(priv_key, from, to, amount)
    # Create signature
    string = from.to_s + "," + to.to_s + "," + amount.to_s
    signature = KeyChain.sign(priv_key, string).unpack('H*') # Unpack hex string
    puts signature

    # Verify
    KeyChain.verify($public_key, signature.pack('H*'), string) # Pack hex string

    # Create tx object
    new_tx = Tx.new(from[0], to, amount, signature[0])

    # Read mempool JSON into cache
    mempool_cache = JsonIO.read("./mempool_dir/mempool.json", Tx)

    # Append tx to mempool cache
    mempool_cache << new_tx

    puts mempool_cache

    # Write mempool to JSON
    # Mine.write_mempool(mempool_cache)
    JsonIO.write("./mempool_dir/mempool.json", mempool_cache)

    puts "Tx sent"
end

# Menu function
def menu()
    puts ""
    puts "Menu: "
    puts "1. See balance"
    puts "2. Send transaction"
    selection = gets.chomp()

    if selection == "1"
        # See balance
        get_balance($pub_address[0])
    elsif selection == "2"
        # Send tx
        puts "Enter recipient address:"
        to = gets.chomp()           # TODO: ver length
        puts "Enter amount:"
        amount = gets.chomp().to_i  # TODO: ver amount available
        send_tx($private_key, $pub_address, to, amount)
    end
end

def main()

    # Load or input keyphrase
    puts "Menu:", "1. Enter keyphrase", "2. Load keyphrase"
    selection = gets.chomp()
    # Init memnonic variable
    memnonic = ""
    if selection == "1"
        # Enter memnonic phrase to unlock your key pair
        puts "Enter keyphrase"
        memnonic = gets.chomp()
    else
        # Load keyphrase
        memnonic = read_key()
    end

    # Generate public/private key pair from memnonic
    $private_key, $public_key = KeyChain.keypair_gen(memnonic)

    # # TODO: Save key pair to file
    if selection == "1"
        puts "Save keyphrase? (Y/n)"
        selection = gets.chomp()
        if selection == "y" || selection == "Y"
            # Saves keyphrase to txt file
            # TODO: encrypt
            write_key(memnonic.to_s)
        end
    end

    # Generate public address
    $pub_address = KeyChain.public_address_gen($public_key)
    puts "Public address:"
    $pub_address.each do |add|
        puts add.to_s
    end

    ## RUN MENU
    while true
        menu()
    end

    # ## CREATES TX SIG
    # # Get tx variables
    # from = "1En7XFBy8CagDCbTTsA6ooAAN79hzNDRG7"
    # to = "1AJuX2PTFbCXhmuDTsjEEyshj7SYcNi3G4"
    # amount = 1
    # signature = KeyChain.sign($private_key, to)

    # Test sign
    # signature = KeyChain.sign($private_key, "Hello, world!")
    # KeyChain.verify($public_key, signature, "Hello, world!")

    # # Test tx mempool
    # new_tx = Tx.new(from, to, amount, signature)
    # Faraday.post("#{URL}:#{PORT}/transaction", from: from, to: to, amount: amount, signature: signature)

    # TODO: Display balance
    # Will require POSTing to node

    # TODO: Send transaction
    # Will require server-side verification of funds
    # Must generate a sender's signature with private key
    # Hash Tx with private key, should be decryptable with public key

end

main()

# TODO: Add signed by to Tx

