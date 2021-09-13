# Creates, views, and updates address transactions and balances.

require "./utils/tx"

require "faraday"
require "./wallet/keychain"

URL = "http://localhost"
PORT = 4567

def send_tx()
    from = "jay"
    to = "rey"
    amount = "1"
    Faraday.post("#{URL}:#{PORT}/transaction", from: from, to: to, amount: amount)
    puts "sent"
end

# Keyphrase read / write function
def write_key(data, address="./wallet/keyphrase.txt")
    File.open(address, "w") do |file|
        file.write(data)
    end
end

def read_key(address="./wallet/keyphrase.txt")
    if File.zero?(address)
        puts "No read data found"
        return false
    else
        file = File.read(address).to_s
        return file
    end
end

def main()

    # # Test tx mempool
    # new_tx = Tx.new("jay", "tessa", 1)
    # Faraday.post("#{URL}:#{PORT}/transaction", from: "Jayden", to: "Tessa", amount: 1)

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
    priv_key, public_key = KeyChain.keypair_gen(memnonic)

    # TODO: Save key pair to file
    puts "Save keyphrase? (Y/n)"
    selection = gets.chomp()
    if selection == "y" || selection == "Y"
        # Saves keyphrase to txt file
        # TODO: encrypt
        write_key(memnonic.to_s)
    end

    # TODO: Display balance
    # Will require POSTing to node

    # TODO: Send transaction
    # Will require server-side verification of funds
    # Must generate a sender's signature with private key
    # Hash Tx with private key, should be decryptable with public key

end

main()

# TODO: Add signed by to Tx

