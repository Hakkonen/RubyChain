require "digest"
require "openssl"

require 'ecdsa'
require 'securerandom'
require 'digest/sha2'

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

# Premade address
group = ECDSA::Group::Secp256k1

# String needs to be converted into integer to be fed into ECC 
address = ("0xbda61a1f5a54c54c7a5c91eb921198122a41bf97026d012165fc7063b7040232").unpack("H*")[0].to_i 
public_add = group.generator.multiply_by_scalar(address)
puts 'public address: '
puts '  x: %#x' % public_add.x
puts '  y: %#x' % public_add.y

# Premade sign

document = "The password is: password"
digest = Digest::SHA2.digest(document)
signature = nil
while signature.nil?
    temp_key = 1 + SecureRandom.random_number(group.order - 1)
    signature = ECDSA.sign(group, address, digest, temp_key)
end

# Fake public key
fake_add = ("0xada61a1f5a54c54c7a5c91eb921198122a41bf97026d012165fc7063b7040232").unpack("H*")[0].to_i 
fake_public_add = group.generator.multiply_by_scalar(fake_add)

#Pre made verifying
#Input (public key, Digest::SHA2.digest(document), signature)

valid = ECDSA.valid_signature?(public_add, digest, signature)
puts "valid: #{valid}"

fake_valid = ECDSA.valid_signature?(fake_public_add, digest, signature)
puts "fake valid: #{fake_valid}"


# # Generating a private key

# # group = ECDSA::Group::Secp256k1
# private_key = 1 + SecureRandom.random_number(group.order - 1)
# puts 'private key: %#x' % private_key

# # Computing the public key

# public_key = group.generator.multiply_by_scalar(private_key)
# puts 'public key: '
# puts '  x: %#x' % public_key.x
# puts '  y: %#x' % public_key.y

# # Compressing

# public_key_string = ECDSA::Format::PointOctetString.encode(public_key, compression: true)
# pp public_key_string

# # Uncompressing

# public_key = ECDSA::Format::PointOctetString.decode(public_key_string, group)
# pp public_key

# # Signing

# message = 'ECDSA is cool.'
# digest = Digest::SHA2.digest(message)
# signature = nil
# while signature.nil?
#     temp_key = 1 + SecureRandom.random_number(group.order - 1)
#     signature = ECDSA.sign(group, private_key, digest, temp_key)
# end
# puts 'signature: '
# puts '  r: %#x' % signature.r
# puts '  s: %#x' % signature.s

# # Verifying

# valid = ECDSA.valid_signature?(public_key, digest, signature)
# puts "valid: #{valid}"

#############################

# # This is the data to wrap
# document = "The password is: password."

# # # Generate key
# key = OpenSSL::PKey::EC.generate("secp256k1")

# # Use generated key
# #key = OpenSSL::PKey.read(File.read())

# pp key.to_der.unpack("H*")[0]

# pub_key = OpenSSL::PKey::EC.new(key.public_key.group)
# pub_key.public_key = key.public_key
# # pp pub_key.to_der.unpack("H*")[0]

# fake_key = OpenSSL::PKey::EC.generate("prime256v1")
# fake_pub_key = OpenSSL::PKey::EC.new(fake_key.public_key.group)
# fake_pub_key.public_key = fake_key.public_key

# signature = key.dsa_sign_asn1(OpenSSL::Digest::SHA256.digest(document))
# # signature = hash_key.dsa_sign_asn1(OpenSSL::Digest::SHA256.digest(document))

# # Verifies signed doc against sig and public key
# verified = pub_key.dsa_verify_asn1(OpenSSL::Digest::SHA256.digest(document), signature)
# # puts verified

# fake_ver = fake_key.dsa_verify_asn1(OpenSSL::Digest::SHA256.digest(document), signature)
# # puts fake_ver

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