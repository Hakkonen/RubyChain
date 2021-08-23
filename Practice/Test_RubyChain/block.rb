# Block class
# A block consists of four elements:
#   1. Prev_hash
#   2. Tx_Root (Merkle root) / Transaction data
#   3. Timestamp
#   4. Nonce
#   5. Data

require "digest"


class Block
    attr_reader :data
    attr_reader :hash
    attr_reader :prev_hash
    attr_reader :nonce
    attr_reader :timestamp

    def initialize(data="", prev_hash)
        @data = data
        @prev_hash = prev_hash
        @hash, @nonce  = create_hash(data, prev_hash)
        @timestamp = Time.now.to_i
    end

    def create_hash(data, last_hash, difficulty="000")
        # Init a nonce, a "number used once" for incrementing random generation of a SHA hash
        nonce = 0

        # Check if hash meets validation
        # More leading "0"s infer more complexity
        # Post-check loop to allow initial hash generation
        loop do
            # Re-generate time for hash
            time = Time.now.to_i

            # Ingest data and combine with nonce, then convert to SHA256 hash
            hash = Digest::SHA256.hexdigest(nonce.to_s + time.to_s + last_hash.to_s + data.to_s)

            # Incerement nonce to allow new hash generation
            nonce += 1
            break if (hash.to_s.start_with?(difficulty) == true)
        end

        # Return succesful hash
        return [hash, nonce]
    end
end
