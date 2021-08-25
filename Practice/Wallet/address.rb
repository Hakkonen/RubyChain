require "digest"
require "openssl"
require "Bitcoin"
require 'starkbank-ecdsa'
require "pp"

# Starting with the public key, we compute the SHA256 Hash and then compute the RUPEMD160 hash of the result, producing a 160-bit (20-byte) number.
# https://www.oreilly.com/library/view/mastering-bitcoin/9781491902639/ch04.html#:~:text=Bitcoin%20uses%20elliptic%20curve%20multiplication,for%20its%20public%20key%20cryptography.&text=When%20spending%20bitcoins%2C%20the%20current,transaction%20to%20spend%20those%20bitcoins.

# A = RIPEMD160( SHA256( K ) )

# key = Bitcoin::Key.generate
# pp key.priv
# pp key.pub
# pp key.addr
# sig = key.sign("data")
# key.verify("data", sig)

# This is the data to wrap
document = "The password is: password."

key = OpenSSL::PKey::EC.generate("prime256v1")
# key = OpenSSL::PKey::EC.new('secp256k1').generate_key
pp key.to_der.unpack("H*")[0]

pub_key = OpenSSL::PKey::EC.new(key.public_key.group)
pub_key.public_key = key.public_key
pp pub_key.to_der.unpack("H*")[0]

signature = key.dsa_sign_asn1(OpenSSL::Digest::SHA256.digest(document))
# signature = hash_key.dsa_sign_asn1(OpenSSL::Digest::SHA256.digest(document))

verified = pub_key.dsa_verify_asn1(OpenSSL::Digest::SHA256.digest(document), signature)
puts verified

##################

# # create a public/private key pair 
# key = OpenSSL::PKey::RSA.new(2048)
# # pp key.to_der.unpack("H*")[0]

# # extract the public key from the pair
# pub_key = OpenSSL::PKey::RSA.new(key.public_key.to_der)
# # pp pub_key

# # To prove that the message was sent by the originator, the sender generates a signature for the message. This is done by the sender using the sender’s private key and the pre-defined digest function:
# signature = key.sign(OpenSSL::Digest::SHA256.new, document)

# # Using the recipient’s public key, the sender will encrypt the plain text:
# encrypted = pub_key.public_encrypt(document)

# # The recipient can now decrypt the message using their private key:
# decrypted = key.private_decrypt(encrypted)
# puts decrypted

# # Finally, the recipient can verify that the message is actually from the sender by checking the signature:
# if pub_key.verify(OpenSSL::Digest::SHA256.new, signature, decrypted)
#     puts "Verified"
# else
#     puts "Failed verification"
# end

################