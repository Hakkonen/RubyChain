# MAKE SURE TO NOTE 3rd PARTY GEMS
require "./utils/sigver"
require "digest"
require "base58"

# For pub key gen
require 'ecdsa'
require 'securerandom'

module KeyChain
    def KeyChain.keypair_gen(string)
        # TODO: Change to return an object
        result = []

        # Generate private key
        private_key = Digest::SHA256.hexdigest string
        puts "Private key:"
        pp private_key
        result.push private_key

        # Generate ECC public key
        group = ECDSA::Group::Secp256k1

        private_key_unpacked = private_key.unpack("H*")[0].to_i 

        # Generate public address from the private key integer
        ecc_public_key = group.generator.multiply_by_scalar(private_key_unpacked)

        puts "Public key:"
        pp ecc_public_key.x
        pp ecc_public_key.y
        result.push ecc_public_key

        return result
    end

    def KeyChain.public_address_gen(public_key)
        results = []

        ##################
        # Compressed public key
        public_key_string = ECDSA::Format::PointOctetString.encode(public_key, compression: false)
        # pp public_key_string.unpack('H*')[0]
        # pp public_key.x
        # pp public_key.y

        # results.push public_key_string

        ##################
        # SHA256 and RIPEMD-160
        sha_encrypted_key = Digest::SHA256.hexdigest public_key_string
        # pp sha_encrypted_key

        ripmd_encrypted_key = Digest::RMD160.hexdigest sha_encrypted_key
        # pp ripmd_encrypted_key

        # results.push ripmd_encrypted_key

        ##################
        # Add network byte
        network_key = "00" + ripmd_encrypted_key
        # pp network_key

        # results.push network_key

        ##################
        # Checksum
        checksum_key_1 = Digest::SHA256.hexdigest network_key
        checksum_key_2 = Digest::SHA256.hexdigest checksum_key_1
        checksum_key = checksum_key_2[0..7]
        # pp checksum_key

        ##################
        # Hash address

        hash_address = network_key + checksum_key
        # pp hash_address

        results.push hash_address

        ##################
        # Base58 key
        # test_key = ["00453233600a96384bb8d73d400984117ac84d7e8b512f43c4"]
        # pp test_key
        # add = test_key.pack('H*')
        # pp add

        add = [hash_address].pack('H*')
        base58_key = Base58.binary_to_base58(add, :bitcoin, true)
        pp base58_key

        results.push base58_key

        # Returns array
        return results
    end
end