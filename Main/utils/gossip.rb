# Runs gossip network functions

require "sinatra"

puts "Starting local node"
get "/node" do
    "Working node"
end

get "/gossip" do
    return 
end