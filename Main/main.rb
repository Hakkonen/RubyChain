require "./utils/sigver"
require "./keychain"

def main()
    # Generate key
    #key = "0x60cf347dbc59d31c1358c8e5cf5e45b822ab85b79cb32a9f3d98184779a9efc2"

    # Need to make this return an object
    priv_key, public_key = KeyChain.keypair_gen("Jayden")

    address = KeyChain.public_address_gen(public_key)

    # "Document" to sign
    trx = [
        "60cf347dbc59d31c1358c8e5cf5e45b822ab85b79cb32a9f3d98184779a9efc2",
        "100",
        "0xada61a1f5a54c54c7a5c91eb921198122a41bf97026d012165fc7063b7040232"
    ]

    signature = SigVer.sign(priv_key, trx)

    # Verify document with public key
    verify = SigVer.verify(public_key, trx, signature)
    pp verify
end

main()