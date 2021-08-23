# https://apidock.com/ruby/Array/pack

require "pp"

def int4( num )
    [num].pack("V")
end

version    = 1
prev_hash       = '0000000000000000000000000000000000000000000000000000000000000000'
merkleroot = '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b'
time       = 1231006505
bits       = '1d00ffff'
nonce      = 2083236893

# Packing functions for little-end
def int4( num )
    # Packs the input as little-endian 32 bit VAX byte order
    [num].pack("V")
end

def hex32 ( hex )
    # Packs the input as a hex string and then reverses
    [hex].pack("H*").reverse 
end

def bin_to_hex32( bytes )
    bytes.reverse.unpack( 'H*' )[0]   ## note: change byte order (w/ reverse)
end

def bin_to_hex( bytes )
    bytes.unpack( 'H*' )[0] # The [0] just unpacks first returned array
end

# Packing functions for big-end
# def int4_b( num )
#     # Packs the input as little-endian 32 bit VAX byte order
#     [num].pack("N")
# end

# def hex32_b ( hex )
#     # Packs the input as a hex string and then reverses
#     [hex].pack("H*") 
# end

pp version
pp int4(version)
# => "\x01\x00\x00\x00"
pp bin_to_hex(int4(version))
# => "01000000"
pp hex32(merkleroot)
# => ";\xA3\xED\xFDz{\x12\xB2z\xC7,>gv\x8Fa\x7F\xC8\e\xC3\x88\x8AQ2:\x9F\xB8\xAAK\x1E^J"
pp bin_to_hex32(hex32(merkleroot))
# => "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b"



# header =
#    int4( version       ) +
# #   hex32( prev_hash          ) +
#   hex32( merkleroot    ) +
#    int4( time          ) +
#    int4( bits.to_i(16) ) +
#    int4( nonce         )

# puts header.length

