# The block class

require "digest"
require "pp"
require "json"

# MAKE USAGE DOCUMENT
# TODO: Fix time issue

class Block
    attr_reader :id
    attr_reader :hash
    attr_reader :prev_hash
    attr_reader :time_stamp
    attr_reader :nonce
    attr_reader :merkle_r
    attr_reader :data
    attr_reader :difficulty

    def initialize(prev_hash, merkle_r, data, id, difficulty="00000", hash=nil, nonce=nil, time_Stamp=nil)
        @prev_hash = prev_hash
        @merkle_r = merkle_r
        @data = data
        @difficulty = difficulty # Amount of leading zeroes

        # Hash/Nonce/Time fields will be empty in a new block mine
        # If fields are filled it will be from regenerating a JSON object
        if hash == nil && nonce == nil && time_stamp == nil
            @id = (id.to_i + 1).to_s
            @hash, @nonce, @time_stamp = mine_block(prev_hash, merkle_r, data, difficulty)
        else
            @id = id.to_s
            @hash = hash
            @nonce = nonce
            @time_stamp = time_stamp
        end
    end

    def mine_block(input_hash, input_merkle, input_data, leading_0)

        # Init nonce
        nonce = 0
        hash_attempt = ""
        time = Time.now.to_i
        t1 = Time.now

        # Mine block
        loop do
            # Get time at block attempt
            time = Time.now.to_i

            hash_attempt = Digest::SHA256.hexdigest(nonce.to_s + input_hash.to_s + input_merkle.to_s + input_data.to_s)

            break if (hash_attempt.to_s.start_with?(leading_0.to_s) == true)
            nonce += 1
        end
        t2 = Time.now
        delta = t2 - t1
        puts "Elapsed Hash Time: %.4f seconds, Hashes Calculated: %d" % [delta,nonce]

        #pp hash, nonce, time_stamp
        return [hash_attempt, nonce, time]
    end

    def to_json(*args)
        {
        JSON.create_id => self.class.name,
        "id" => id,
        "hash" => hash,
        "prev_hash" => prev_hash,
        "merkle_r" => merkle_r,
        "data" => data,
        "time_stamp" => time_stamp.to_i,
        "nonce" => nonce,
        "difficulty" => difficulty,
        }.to_json(*args)
    end
    
    def self.json_create(h)
        new(h["prev_hash"], h["merkle_r"], h["data"], h["id"], h["difficulty"], h["hash"], h["nonce"], h["time_stamp"])
    end
end