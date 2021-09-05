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

        # Else return false, no match found
        if block.id.to_s == "1"
            puts "CHAIN VALID"
        else
            puts "INVALID - Block: " + block.id.to_s + " has no correlating hash"
            return false
        end
    end

    # Takes in chain and checks all hashes against previous hashes
    def Verify.chain(chain)
        # Iterates through whole array
        chain.ledger["mainnet"].each do |block|
            # Then compares prev_hash to other blocks to find a match
            Verify.correlate_hash(chain, block)
        end
    end
end