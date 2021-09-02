require "./block"
require "pp"

module Mine
    



    def Mine.mine_block(prev_hash, merkle_r, data, difficulty)
        # Returns block object after succesful mine
        return Block.new(prev_hash, merkle_r, data, difficulty)
    end
end