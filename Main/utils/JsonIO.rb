# Reads and writes JSON data
require "./node/block"
require "./utils/tx"
require "json"
require "pp"

module JsonIO
    # Reads JSON data and parses into array to return
    # Input object type to rereate from JSON, ie: Block or Tx
    def JsonIO.read(address, object_type)
        cache = []
        # If file is empty, ask to make first block
        if File.zero?(address)
            puts "No read data found"
            return cache
        else
        # Else ingest file JSON data
            file = File.read(address)
            hash = JSON.parse(file)
        end

        # Converts JSON file to array of objects
        objectify = []
        hash.each do |item|
            cache << object_type.json_create(item)
        end

        # Return JSON parsed ledger
        return cache
    end

    # Writes array of objects to JSON
    # Address is file location, data is JSON object data
    def JsonIO.write(address, data)
        # Save mempool into file
        File.open(address, "w+") do |file|
            # Write JSON blockchain data to file
            file.write(data.to_json)
        end
    end
end