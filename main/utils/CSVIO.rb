require "csv"

module CSV
    def CSVIO.read(address)
        csv = []
        CSV.read(address, "w") do |csv|
            csv << [] # add headers
            csv.each do |row|
            
        end
    end
end