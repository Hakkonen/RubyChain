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

# Packing functions for big-end
def int4_b( num )
    # Packs the input as little-endian 32 bit VAX byte order
    [num].pack("N")
end

def hex32_b ( hex )
    # Packs the input as a hex string and then reverses
    [hex].pack("H*") 
end

# As little-end
pp header =
   int4( version       ) +
  hex32( prev_hash          ) +
  hex32( merkleroot    ) +
   int4( time          ) +
   int4( bits.to_i(16) ) +
   int4( nonce         )

# As big-end
pp header =
   int4_b( version       ) +
  hex32_b( prev_hash          ) +
  hex32_b( merkleroot    ) +
  int4_b( time          ) +
   int4_b( bits.to_i(16) ) +
   int4_b( nonce         )


# header2 = 
# version +   
# prev_hash +
# merkleroot +
# time +
# bits.to_i(16) +
# nonce

puts header.length

# pp header
# pp int4(version)
# pp bin_to_hex(header)
# pp bin_to_hex(int4(version))

