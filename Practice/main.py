from blockchain import Blockchain

blockchain = Blockchain()

blockchain.add_new_block("First Block")
blockchain.add_new_block("Second Block")
blockchain.add_new_block("Third Block")
blockchain.add_new_block("Fifth Block")
blockchain.add_new_block("Sixth Block")
blockchain.add_new_block("Seventh Block")
blockchain.add_new_block("Eigth Block")
blockchain.add_new_block("Ninth Block")
blockchain.add_new_block("Tenth Block")

for block in blockchain.get_blocks():
    print()
    print(block.to_string())