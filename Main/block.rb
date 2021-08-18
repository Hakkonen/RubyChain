# block class
# A block consists of four elements:
#   1. Prev_hash
#   2. Tx_Root (Merkle root) / Transaction data
#   3. Timestamp
#   4. Nonce
#   5. Data

require "digest"


class Block
    def initialize(data="100BTC", prev_hash="00000000")
        @data = data.to_s
        @prev_hash = prev_hash.to_s
        @hash = create_hash(data, prev_hash)
        @timestamp = Time.now.getutc
    end

    def validate_hash(input_hash)
        return input_hash.match?(/^000/)
    end

    def create_hash(data, last_hash)
        # Init a nonce, a procedural implement for finding the right hash
        nonce = 0

        # Ingest data and combine with nonce, then convert to SHA256 hash
        new_hash = Digest::SHA256.hexdigest(last_hash.to_s + data.to_s + nonce.to_s)

        # Check if hash meets validation
        # More leading "0"s infer more complexity
        while(validate_hash(new_hash) == false)
            # Incerement nonce to allow new hash generation
            nonce +=1

            # Generate new hash
            new_hash = Digest::SHA256.hexdigest(last_hash.to_s + data.to_s + nonce.to_s)
        end

        puts(new_hash)
        return new_hash
    end
end