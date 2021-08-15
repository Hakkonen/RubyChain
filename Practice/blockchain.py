# From https://levelup.gitconnected.com/creating-a-blockchain-from-scratch-9a7b123e1f3e

from block import Block

class Blockchain():
    # construct the blockchain class
    def __init__(self):
        self.blocks = []
        self.set_genesis_block()

    # create method to mint genesis block
    def set_genesis_block(self):
        data = "Genesis\t"
        prev_hash = "0"*64
        genesis_block = Block(data, prev_hash)
        self.blocks.append(genesis_block)

    # reads last block, returns hash of last block
    def get_last_hash(self):
        last_block = self.blocks[-1]
        last_hash = last_block.hash
        return last_hash

    # forges new block
    def add_new_block(self, data):
        # read previous block's hash
        prev_hash = self.get_last_hash()
        # create new block, feed in data and previous hash
        new_block = Block(data, prev_hash)
        # append new block to chain
        self.blocks.append(new_block)

    # returns blockchain
    def get_blocks(self):
        return (self.blocks)