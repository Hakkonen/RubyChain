# The block class
require "pp"
require "json"

class Block
    attr_reader :hash
    attr_reader :prev_hash
    attr_reader :time_stamp
    attr_reader :nonce
    attr_reader :merkle_r
    attr_reader :data
    attr_reader :difficulty

    def initialize(prev_hash, merkle_r, data, difficulty="000")
        @prev_hash = prev_hash
        @merkle_r = merkle_r
        @data = data

        @difficulty = difficulty # Amount of leading zeroes
        @hash, @nonce, @time_stamp = mine_block(prev_hash, merkle_r, data, difficulty)
    end

    def to_json(*args)
        {
        JSON.create_id => self.class.name,
        "hash" => hash.to_s,
        "prev_hash" => prev_hash,
        "merkle_r" => merkle_r,
        "data" => data,
        "time_stamp" => time_stamp,
        "nonce" => nonce,
        "difficulty" => difficulty,
        }.to_json(*args)
    end
    
    def self.json_create(h)
        new(h["hash"], h["prev_hash"], h["merkle_r"], h["data"], h["time_stamp"], h["nonce"], h["difficulty"])
    end

    def mine_block(input_hash, input_merkle, input_data, leading_0)
        # Init nonce
        nonce = 0
        hash_attempt = ""
        time = Time.now.to_i

        # Mine block
        loop do
            # Get time at block attempt
            time = Time.now.to_i

            hash_attempt = Digest::SHA256.hexdigest(nonce.to_s + input_hash.to_s + input_merkle.to_s + input_data.to_s)

            break if (hash_attempt.to_s.start_with?(leading_0.to_s) == true)
            nonce += 1
        end

        #pp hash, nonce, time_stamp
        return [hash_attempt, nonce, time]
    end
end