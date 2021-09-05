# Verifies chain hash integrity

module Verify
    def Verify.correlate_hash(chain, block)
        chain.ledger["mainnet"].each do |search_block|
            # Loads current block's prev_hash and ID
            search_prev_hash = block.prev_hash.to_s
            current_id = block.id

            # If a block is found to have a hash that matches do:
            if search_block.hash.include? search_prev_hash
                puts "VALID — ID: " + current_id.to_s + " -> " + search_block.id.to_s
                return true
            end
        end

        # Else check if last block
        if block.id.to_s == "1"
            puts "CHAIN VALID", ""
        else
            # Otherwise return INVALID, blockchain is broken
            puts "INVALID - Block: " + block.id.to_s + " has no correlating hash"
            return false
        end
    end

    # Takes in chain and checks all hashes against previous hashes
    def Verify.chain(chain)
        id = (chain.ledger["mainnet"].length.to_i - 1)

        # Iterates through whole array
        while id >= 0
            Verify.correlate_hash(chain, chain.ledger["mainnet"][id])
            id -= 1
        end
    end
end