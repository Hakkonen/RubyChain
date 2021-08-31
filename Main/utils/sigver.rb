require 'ecdsa'
require 'securerandom'
require 'digest/sha2'

require "pp"

module SigVer
    def SigVer.sign(private_key_string, document)
        group = ECDSA::Group::Secp256k1

        # Convert private key string into integer for ECC Pub Key generation
        # May require 0x on prefix depending on input
        priv_key = private_key_string.unpack("H*")[0].to_i 

        # Sign document with private key
        digest = Digest::SHA2.digest(document.to_s)
        signature = nil
        while signature.nil?
            temp_key = 1 + SecureRandom.random_number(group.order - 1)
            signature = ECDSA.sign(group, priv_key, digest, temp_key)
        end

        return signature
    end

    ############################################
    # Deprecated
    # def SigVer.gen_pub_key(private_key_string)
    #     group = ECDSA::Group::Secp256k1

    #     priv_key = private_key_string.unpack("H*")[0].to_i 

    #     # Generate public address from the private key integer
    #     return group.generator.multiply_by_scalar(priv_key)
    # end

    def SigVer.verify(public_key, document, signature)
        # Doc may need to be digested as string?
        digest = Digest::SHA2.digest(document.to_s)
        return ECDSA.valid_signature?(public_key, digest, signature)
    end
end