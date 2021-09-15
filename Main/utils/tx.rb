# The class for transactions

require "./wallet/keychain"

require "digest"
require "json"

class Tx
    attr_reader :sender
    attr_reader :receiver
    attr_reader :amount
    attr_reader :signature
    attr_reader :merkle_hash

    def initialize(sender, receiver, amount, signature, merkle_hash=nil)
        @sender = sender # Public address
        @receiver = receiver # Public key hash
        @signature = signature
        @amount = amount

        # Allows for reconstruction of merkle from JSON object
        if merkle_hash == nil
            @merkle_hash = create_merkle(sender, receiver, amount)
        else
            @merkle_hash = merkle_hash
        end
    end

    def create_merkle(from, to, quantity)
        return Digest::SHA256.hexdigest(from.to_s + to.to_s + quantity.to_s).to_s
    end

    # Converts to JSON object
    def to_json(*args)
        {
        JSON.create_id => self.class.name,
        "sender" => sender,
        "receiver" => receiver,
        "amount" => amount,
        "signature" => signature,
        "merkle_hash" => merkle_hash.to_s
        }.to_json(*args)
    end

    # Rebuilds from JSON object
    def self.json_create(h)
        new(h["sender"], h["receiver"], h["amount"], h["signature"], h["merkle_hash"])
    end
end