# Creates, views, and updates address transactions and balances.

require "./node/block"
require "./node/blockchain"
require "./utils/verify"
require "./utils/loop"
require "./utils/tx"
require "./utils/JsonIO.rb"   # Imports read write func for JSON data

require "json"
require "./wallet/keychain"

## TODO
# 1. Add check balance
# 2. Add send money

## Order of operation:
# 1. Load key
#    a. From saved file
#    b. From manual entry
#        i. Save entered key
# 2. Menu for wallet functions
#   a. Check balance
#   b. Send transaction
#   c. Display keypair

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

# Reads blockchain for balances
def get_balance(address)
    # TODO: Needs to count sent AND received for total

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

    return balance
end

# Creates TX object from values and sends to mempool
## TODO: Verify balance before sending
def send_tx(priv_key, from, to, amount)
    # Get balance before creating TX
    balance = get_balance($pub_address)
    if amount > balance
        puts "INSUFFICIENT FUNDS"
    else
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
end

# Display keypair
def display_keypair()
    puts "Private key INT: " + $private_key.to_s
    puts 'private key HEX: %#x' % $private_key
    puts ""
    puts "Public key: "
    puts '  x: %#x' % $public_key.x
    puts '  y: %#x' % $public_key.y
    puts ""
    puts "Public Address: " + $pub_address[0].to_s
end

# Menu function
def menu()
    puts ""
    puts "Menu: "
    puts "1. See balance"
    puts "2. Send transaction"
    puts "3. Display Priv/Pub keypair"
    selection = gets.chomp()

    if selection == "1"
        # Display balance
        puts ""
        puts "BALANCE: " + get_balance($pub_address[0]).to_s + " RubyCoins"
    elsif selection == "2"
        # Send tx
        puts "Enter recipient address:"
        to = gets.chomp()           # TODO: ver length
        puts "Enter amount:"
        amount = gets.chomp().to_i  # TODO: ver amount available
        send_tx($private_key, $pub_address, to, amount)
    elsif selection == "3"
        display_keypair()
    end
end

def main()

    # Load or input keyphrase
    puts "Menu:", "1. Load keyphrase", "2. Enter keyphrase"
    selection = gets.chomp()
    
    # Init memnonic variable
    memnonic = ""
    if selection == "1"
        # Load keyphrase
        memnonic = read_key()
    elsif selection == "2"
        # Enter memnonic phrase to unlock your key pair
        puts "Enter keyphrase"
        memnonic = gets.chomp()
    end

    # Generate public/private key pair from memnonic
    $private_key, $public_key = KeyChain.keypair_gen(memnonic)

    # Ask to save keypair if new memnonic
    if selection == "2"
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
    puts ""
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

end

main()

