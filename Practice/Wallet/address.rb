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


message = "9000"
public_key = "040c1fbe8b870d636823963ff21ba6e5250571848714203a08ae8700e0d97a1d7bb94ae888af72ac9a4fe02d558599d27c8986398902fa9ac0c1654f5839db1af5"
private_key = "2ec6d2808dc7b9d11e49516cfc747435feae8e9872d63c92bc5bde68a894199f"

require 'starkbank-ecdsa'

# # StarkBank gem
# privateKey = EllipticCurve::PrivateKey.new()
# pp 
# publicKey = privateKey.publicKey()

# message = "My test message"

# # Generate Signature
# signature = EllipticCurve::Ecdsa.sign(message, privateKey)

# # Verify if signature is valid
# puts EllipticCurve::Ecdsa.verify(message, signature, publicKey)

# Hash message — Double hashing step
# def hash(msg)
#     result = Digest::SHA256.hexdigest(msg)
#     return Digest::RMD160.hexdigest(result)
# end

# def createSignature(msg, private_k)
#     MESSAGE_HASH = hash(message)
#     PRIV_KEY_PAIR = EC
#     SIGNATURE = 
# end

# SHA256
# private_key = "Hello world!"
# public_ad = Digest::SHA256.hexdigest(private_key)
# pp public_ad
# pp public_ad.length

# EC

example_key = OpenSSL::PKey::EC.new('secp256k1').generate_key
pp example_key.to_pem
private_key = example_key.private_key
pp private_key.to_pem

group = OpenSSL::PKey::EC::Group.new('secp256k1')
public_key = group.generator.mul(private_key)

puts example_key.public_key == public_key # => true

# RIPEMD160
# wallet_ad = Digest::RMD160.hexdigest(public_ad)
# pp wallet_ad
# pp wallet_ad.length

# pp "1J7mdg5rbQyUHENYdx39WVWK7fsLpEoXZy"
# pp "1J7mdg5rbQyUHENYdx39WVWK7fsLpEoXZy".length