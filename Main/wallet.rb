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

def main()

    # Enter memnonic phrase to unlock your key pair
    puts "Enter keyphrase"
    memnonic = gets.chomp()

    # Generate public/private key pair from memnonic
    priv_key, public_key = KeyChain.keypair_gen(memnonic)

    # TODO: Save key pair to file

    # TODO: Display balance
    # Will require POSTing to node

    # TODO: Send transaction
    # Will require server-side verification of funds
    # Must generate a sender's signature with private key

end

main()

# TODO: Add signed by to Tx

