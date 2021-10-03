Thread.abort_on_exception = true

module Loop
    def Loop.repeat_every(seconds)
        # Opens new processing thread
        Thread.new do
            loop do
                sleep seconds
                yield
            end
        end
    end

    
end