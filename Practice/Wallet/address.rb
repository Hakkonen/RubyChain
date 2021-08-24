require "digest"

# Starting with the public key, we compute the SHA256 Hash and then compute the RUPEMD160 hash of the result, producing a 160-bit (20-byte) number.
# https://www.oreilly.com/library/view/mastering-bitcoin/9781491902639/ch04.html#:~:text=Bitcoin%20uses%20elliptic%20curve%20multiplication,for%20its%20public%20key%20cryptography.&text=When%20spending%20bitcoins%2C%20the%20current,transaction%20to%20spend%20those%20bitcoins.

# A = RIPEMD160( SHA256( K ) )

private_key = "Hello world!"
public_ad = Digest::SHA256.hexdigest(private_key)
pp public_ad
pp public_ad.length
wallet_ad = Digest::RMD160.hexdigest(public_ad)
pp wallet_ad
pp wallet_ad.length

pp "1J7mdg5rbQyUHENYdx39WVWK7fsLpEoXZy"
pp "1J7mdg5rbQyUHENYdx39WVWK7fsLpEoXZy".length