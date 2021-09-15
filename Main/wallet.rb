# Creates, views, and updates address transactions and balances.

require "./utils/tx"

require "faraday"
require "./wallet/keychain"

URL = "http://localhost"
PORT = 4567

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

# Gets account balance
def get_balance(address)
    # Sends address to server
    res = Faraday.get("#{URL}:#{PORT}/balance", address: address).body
    # Returns response
    puts res
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
    private_key, public_key = KeyChain.keypair_gen(memnonic)

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
    pub_address = KeyChain.public_address_gen(public_key)
    puts "Public address:"
    pub_address.each do |add|
        puts add.to_s
    end

    # Get tx variables
    from = "1En7XFBy8CagDCbTTsA6ooAAN79hzNDRG7"
    to = "1AJuX2PTFbCXhmuDTsjEEyshj7SYcNi3G4"
    amount = 1
    signature = KeyChain.sign(private_key, to)

    # Test sign
    # signature = KeyChain.sign(private_key, "Hello, world!")
    # KeyChain.verify(public_key, signature, "Hello, world!")

    # # Test tx mempool
    # new_tx = Tx.new(from, to, amount, signature)
    # Faraday.post("#{URL}:#{PORT}/transaction", from: from, to: to, amount: amount, signature: signature)

    get_balance(pub_address)

    # TODO: Display balance
    # Will require POSTing to node

    # TODO: Send transaction
    # Will require server-side verification of funds
    # Must generate a sender's signature with private key
    # Hash Tx with private key, should be decryptable with public key

end

main()

# TODO: Add signed by to Tx

