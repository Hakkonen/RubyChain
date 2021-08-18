# operates the blockchain

# How to require an external class 
# require_relative "test_block"

require_relative "blockchain"
require_relative "block"

def generate_blockchain(array)
    # 1. Generate blockchain array
    array = Blockchain.new

    # Print blockchain object
    print "Ruby Chain created: "
    puts array

    return array
end

def initialise_genesis_block(data)
    # 2. Initalise genesis block
    genesis_block = Block.new(data.to_s, 0)

    # Demonstrate genesis block
    p genesis_block

    return genesis_block
end

# Takes string question and returns true or false
def menu(phrase)
    if phrase.class == "Array"
        phrase.each do | line |
            puts line
        end
    else
        puts phrase
    end

    selection = ""

    while selection == ""
        selection = gets.chomp()
        if selection = "Y" || selection = "y"
            return true
        elsif selection "N" || selection = "n"
            return false
        else
            selection = ""
            puts phrase.to_s + " (Y/n)"
            selection = gets.chomp()
        end
    end
end

def main()
    # How to import class below
    # genesis = Block.new
    
    # p genesis
    # genesis.test()
    # -------------------------

    # Scoped variables
    ruby_chain = []

    # Menu
    # Start blockchain
    start_chain = menu(["Welcome to RubyChain\n", "Generate blockchain? (Y/n)"])
    if start_chain
        generate_blockchain(ruby_chain)
    else
        puts "Exiting"
        exit
    end

    # Start genesis block
    start_genesis = menu("Generate genesis block? (Y/n)")

    if start_genesis == true
        # Create and add genesis block to chain
        ruby_chain.push initialise_genesis_block(18370000)

        # Show chain
        # inspect ruby_chain.to_s
    end

    
end

main()