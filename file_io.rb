class String
    def br_to_new_line
        self.gsub('<br>', "\n")
    end
    def n_to_nil
        self.gsub('\n', "")
    end
    def strip_tag
        self.gsub(%r[<[^>]*>], '').gsub(/\t|\n|\r/, ' ')
    end
end #String

class IoFactory
        attr_reader :file
        def self.init file
                @file = file
                if @file.nil?
                        puts 'Can Not Init File To Write'
                        exit
                end #if
                File.open @file, 'a'
        end
end #IoFactory