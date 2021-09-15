require "./node/mine"
require "./node/block"
require "./node/blockchain"
require "./utils/verify"
require "./utils/loop"
require "./utils/tx"
require "./utils/JsonIO.rb"   # Imports read write func for JSON data

require "sinatra"
require 'active_support/time'

require "pp"

def main()
    # Init mempool cache
    mempool_cache = []

    priv_key = 115335360685654162973287969678398334977571598484342465176857526594940809651928

    # Create new tx object
    from = "1En7XFBy8CagDCbTTsA6ooAAN79hzNDRG7"
    to = "1AJuX2PTFbCXhmuDTsjEEyshj7SYcNi3G4"
    amount = 1
    signature = KeyChain.sign(priv_key, (amount.to_s + to.to_s))
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
    mempool_cache = JsonIO.read("./ledger/ledger.json", Tx)

    # TODO: Checksum against account balances

    # Append tx to mempool cache
    mempool_cache << new_tx

    puts "Mempool read:"
    pp mempool_cache

    # Write mempool to JSON
    # Mine.write_mempool(mempool_cache)
    JsonIO.write("./mempool_dir/mempool.json", mempool_cache)
end

main()