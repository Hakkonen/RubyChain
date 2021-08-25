require "./utils/sigver"
require "digest"

# Returns array:
# 1. ECC public key object
# 2. Compressed pub key
# 3. 

module Wallet
    def Wallet.public_key_generation(private_key)
        results = []

        # Generate public key
        public_key = Sigver.gen_pub_key(private_key)
        results.push public_key

        # Compressed public key
        public_key_string = ECDSA::Format::PointOctetString.encode(public_key, compression: true)
        results.push public_key_string

        # pp public_key_string.unpack("H*").first
        # pp public_key_string.unpack("H*").first.length
        # pp public_key.x
        # pp public_key.y

        # SHA256 and RIPEMD-160
        sha_encrypted_key = Digest::SHA256.hexdigest public_key_string
        # pp sha_encrypted_key

        ripmd_encrypted_key = Digest::RMD160.hexdigest sha_encrypted_key
        # pp ripmd_encrypted_key

        results.push ripmd_encrypted_key

        return results
    end
end