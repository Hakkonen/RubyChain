module Endian
    def to_8bit_lit_end_i( num )
        [num].pack("V")
    end

    def to_lit_end_hex32( hex )
        [hex].pack("H*").reverse # Note: Reverse is only for little-endianness
    end

    def from_8bit_lit_end_i( bytes )
        [bytes].unpack("H*")[0] # The [0] unpacks first returned array
    end

    def from_hex32_lit_end( bytes )
        [bytes].reverse.unpack("H*")[0]
    end
end