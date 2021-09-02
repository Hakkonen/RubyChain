# Runs node and mines blocks adding data from mempool to the blockchain
require "./node/mine"
require "./wallet"

require "pp"

def main() 
    # puts "Run node?"
    # selection = gets.chomp()
    # if selection == "y" || selection == "Y"
    #     # Run mining
    #     Mine.run()
    # end

    Mine.run()
end

main()