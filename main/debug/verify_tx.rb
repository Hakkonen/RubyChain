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

    # Read mempool JSON into cache
    mempool_cache = JsonIO.read("./mempool_dir/mempool.json", Tx)

    # TODO: Checksum against account balances
    
end