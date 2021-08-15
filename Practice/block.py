from hashlib import sha256
from datetime import datetime

class Block():
    # construct class of block
    def __init__(self, data, previous_block_hash):
        self.timestamp = datetime.utcnow()
        self.data = data
        self.previous_block_hash = previous_block_hash
        self.hash = sha256(self.to_string().encode()).hexdigest()

    # determine if a SHA256 output is valid
    # if the input string leads with three zeroes return true, else return false
    def is_hash_valid(self, hash):
        return (hash.startswith("0" * 3))

    # runs hash function until valid hash is mined
    def calculate_valid_hash(self):
        # initiate empty hash/nonce vars
        hash = ""
        nonce = 0

        # while SHA256 output is false, do
        while (not self.is_hash_valid(hash)):
            # combine data and nonce into string and place into temp var
            temp = self.to_string() + str(nonce)
            # input string of data and nonce into the hash function
            hash = sha256(temp.encode()).hexdigest()
            # increment nonce
            nonce += 1
            # if output does not have three leading zeroes, repeat

        self.hash = hash

    # takes input and formats to string
    def to_string(self):
        # 0 takes first argument, 1 takes second argument
        return "{0}\t{1}".format(self.data, self.timestamp, self.previous_block_hash)