def to_32bit_bin( num )
    [num].pack("V")
end

def to_lit_end( hex )
    [hex].pack("H*").reverse # Note: Reverse is only for little-endianness
end

def from_32bit_bin( bytes )
    [bytes].unpack("H*")[0] # The [0] unpacks first returned array
end

def from_lit_end( bytes )
    [bytes].reverse.unpack("H*")[0]
end