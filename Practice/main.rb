require "./utils/sigver"
require "./keychain"
require "./block"
require "./mine"
require "./blockchain"

require "pp"
require "csv"

def generate_key()
    # Generate key
    pepe = "perfectly spend lifeless experience use avoid edge math anywhere kitchen minute admire"

    # TODO: Need to make this return an object
    priv_key, public_key = KeyChain.keypair_gen(pepe)

    address = KeyChain.public_address_gen(public_key)

    # "Document" to sign
    trx = [
        "60cf347dbc59d31c1358c8e5cf5e45b822ab85b79cb32a9f3d98184779a9efc2",
        "100",
        "0xada61a1f5a54c54c7a5c91eb921198122a41bf97026d012165fc7063b7040232"
    ]

    signature = SigVer.sign(priv_key, trx)

    # Verify document with public key
    verify = SigVer.verify(public_key, trx, signature)
    pp verify
end

def start_mine(blockchain, ledger_addr)
    count = 0

    while count < 3
        # Load ledger data
        ruby_chain = Blockchain.read_ledger("./ledger/ledger.json")

        # Run mining func
        ruby_chain.push Blockchain.mine(ruby_chain, "./mempool_dir/mempool.txt")

        count += 1
    end

    puts "FINAL BLOCKCHAIN"
    pp ruby_chain
end

def init_blockchain(file_dir)
    # Open ledger json
    file = File.read(file_dir, "w+")

    # Parse file data
    data_hash = JSON.parse(file)
end

def main()
    ruby_chain = [] #init_blockchain("./ledger/ledger.json")

    puts "MENU"
    puts "1. Generate Key"
    puts "2. Check Wallet"
    puts "3. Mine blocks"
    puts "4. View ledger"
    selection = gets.chomp()
    if selection == "1"
        generate_key()
    elsif selection == "3"
        start_mine(ruby_chain, "./ledger/ledger.json")
    end
end

main()