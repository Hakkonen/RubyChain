# Takes input string and returns SHA256 hash
require 'digest'

def sha256_encode(string)
    new_hash = Digest::SHA256.hexdigest(string)

    return new_hash
end

def main()
    puts("Enter string to convert to SHA256:")
    input = gets.chomp()
    encoded_input = sha256_encode(input)
    puts encoded_input
end

main()

# Example of SHA256 digest: puts(Digest::SHA256.hexdigest 'Hello world')

