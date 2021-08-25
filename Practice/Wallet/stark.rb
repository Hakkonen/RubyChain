require 'starkbank-ecdsa'
require "pp"

# Generate privateKey from PEM string
# privateKey = EllipticCurve::PrivateKey.fromPem("-----BEGIN EC PARAMETERS-----\nBgUrgQQACg==\n-----END EC PARAMETERS-----\n-----BEGIN EC PRIVATE KEY-----\nMHQCAQEEIODvZuS34wFbt0X53+P5EnSj6tMjfVK01dD1dgDH02RzoAcGBSuBBAAK\noUQDQgAE/nvHu/SQQaos9TUljQsUuKI15Zr5SabPrbwtbfT/408rkVVzq8vAisbB\nRmpeRREXj5aog/Mq8RrdYy75W9q/Ig==\n-----END EC PRIVATE KEY-----\n")
privateKey = EllipticCurve::PrivateKey.new()
pp privateKey

message = "Hello, world!"

signature = EllipticCurve::Ecdsa.sign(message, privateKey)

# Generate Signature in base64. This result can be sent to Stark Bank in header as Digital-Signature parameter
puts signature.toBase64()

# To double check if message matches the signature
publicKey = privateKey.publicKey()

puts EllipticCurve::Ecdsa.verify(message, signature, publicKey)