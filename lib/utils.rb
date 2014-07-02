module Utils
    def self.print_usage
        puts "primord-metadata <directive> ...\n\tSee https://github.com/floomby/primord-tools for more info"
    end
    # get date the file was created from the filename
    def self.extract_date str
        a = str.match /.*([0-9]{4})([0-9]{2})([0-9]{2})/
        "#{a[2]}-#{a[3]}-#{a[1]}"
    end
end # module Utils
