# Runs the software

require_relative "blockchain"
require_relative "block"
require "pp"

def generate_blockchain(array)
    # 1. Generate blockchain array
    array = Blockchain.new

    # Print blockchain object
    print "Ruby Chain created: "
    puts array

    return array
end

def initialise_genesis_block(data, prev)
    # 2. Initalise genesis block
    genesis_block = Block.new(data, prev)

    # Demonstrate genesis block
    p genesis_block

    return genesis_block
end

def mine_block(data, prev)
    return Block.new(data, prev)
end

def validate_chain(array)
    # Checks block hash to prev block hash
    if array[-1].prev_hash.to_s.eql?(array[-2].hash.to_s) == false
        return false
    end

    # Checks block time to ensure chronological seq
    # Does not work while blocks are being generated within the same second
    # if array[-1].timestamp.to_i > array[-2].timestamp.to_i == false
    #     return false
    # end

    return true
end

def main_menu()
    puts "Menu:"
    puts "1 - View chain"
    puts "2 - Validate chain"
    puts "3 - Mine blocks"

    selection = gets.chomp()
    if selection.to_s == "2" || selection.includes?("Validate") || selection.include?("validate")
        validate_chain($ruby_chain)
    end
end

# Takes string question and returns true or false
def menu_select(phrase)
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
        if selection == "Y" || selection == "y"
            return true
        elsif selection == "N" || selection == "n"
            return false
        else
            selection == ""
            puts phrase.to_s + " (Y/n)"
            selection = gets.chomp()
        end
    end
end

def main()
    # Scoped variables
    $ruby_chain = []

    # menu_selectmenu_select
    # Start blockchain
    start_chain = menu_select(["Welcome to RubyChain\n", "Generate blockchain? (Y/n)"])
    if start_chain
        generate_blockchain($ruby_chain)
    else
        # Otherwise generate custom block
        generate_custom_block = menu_select("Generate custm block? (Y/n)")
        if generate_custom_block
            puts "Enter your data: "
            custom_data = gets.chomp()

            puts "Enter your prev hash: "
            custom_prev_hash = gets.chomp()

            custom_block = Block.new(custom_data.to_s, custom_prev_hash.to_s)
            puts custom_block.to_s
            exit
        else
            puts "Exiting"
            exit
        end
    end

    # Start genesis block
    start_genesis = menu_select("Generate genesis block? (Y/n)")

    if start_genesis == true
        # Create and add genesis block to chain
        $ruby_chain.push initialise_genesis_block(
            "18370000",
            "0000000000000000000000000000000000000000000000000000000000000000"
        )

        example_mine_block = menu_select("Example mine_block? (Y/n)")
        if example_mine_block
            # Example mining
            count = 0
            while count < 4
                # Mine block
                $ruby_chain.push mine_block("Hello, crypto!", $ruby_chain[-1].hash)

                # Check validity
                if validate_chain($ruby_chain)
                    puts $ruby_chain[-1].to_s + " is VALID"
                else
                    puts "INVALID BLOCK FOUND"
                    puts $ruby_chain[-1].to_s
                end

                # Increase nonce
                count += 1
            end
        end

        # Show chain
        if menu_select("Show chain?") == true
            pp $ruby_chain
        end

        # main_menu()
    end




    # TODO
    # Merkle tree
    # Create mining func
    # Insert new data into each new block
    # Create a wallet that reads addresses / transfers
end

main()