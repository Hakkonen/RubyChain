# Generates private/public key pairs

# MAKE SURE TO NOTE 3rd PARTY GEMS
require "./utils/sigver"
require "digest"
require "base58"

# For pub key gen
require 'ecdsa'
require 'securerandom'

module KeyChain
    def KeyChain.keypair_gen(string)
        # Returns private key [0] and public key [1]
        result = []

        # Define security group
        group = ECDSA::Group::Secp256k1

        # Generate private key
        private_key = Integer("0x" + Digest::SHA256.hexdigest(string).to_s).to_i
        # puts "Private key:"
        # pp private_key
        # puts 'private key: %#x' % private_key
        result.push private_key

        # Generate public address from the private key integer
        ecc_public_key = group.generator.multiply_by_scalar(private_key)
        # puts "Public key: "
        # puts '  x: %#x' % ecc_public_key.x
        # puts '  y: %#x' % ecc_public_key.y

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

        # results.push hash_address

        ##################
        # Base58 key
        # test_key = ["00453233600a96384bb8d73d400984117ac84d7e8b512f43c4"]
        # pp test_key
        # add = test_key.pack('H*')
        # pp add

        add = [hash_address].pack('H*')
        base58_key = Base58.binary_to_base58(add, :bitcoin, true)
        # pp base58_key

        results.push base58_key

        # Returns array
        return results
    end

    # USAGE: input private key and string to sign
    def KeyChain.sign(private_key, string)
        group = ECDSA::Group::Secp256k1
        digest = Digest::SHA2.digest(string)
        signature = nil
        while signature.nil?
            temp_key = 1 + SecureRandom.random_number(group.order - 1)
            signature = ECDSA.sign(group, Integer(private_key.to_s), digest, temp_key)
        end
        # puts 'signature: '
        # puts '  r: %#x' % signature.r
        # puts '  s: %#x' % signature.s

        signature_der_string = ECDSA::Format::SignatureDerString.encode(signature)

        # pp signature
        # pp signature_der_string

        return signature_der_string
    end

    # USAGE: Input public key, der formatted signature, and original string
    def KeyChain.verify(public_key, der_string, string)
        # Decode DER
        signature = ECDSA::Format::SignatureDerString.decode(der_string)
        digest = Digest::SHA2.digest(string)

        valid = ECDSA.valid_signature?(public_key, digest, signature)
        puts "Signature validity: #{valid}"
        # Returns true or false
        return valid
    end
end