# Module for creating the merkle root

require "digest"

module Merkle_r
    def Merkle_r.ingest(tx_1, tx_2)
        # Takes in two transactions and creates a fingerprint hash
        return Digest::SHA256.hexdigest(tx_1.to_s, tx_2.to_s)
    end
end