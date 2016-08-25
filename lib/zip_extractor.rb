require File.join(File.dirname(__FILE__), 'file_extractor')
require 'zip'

module HTTPExtractor

  class ZipExtractor < FileExtractor

    def initialize(url = nil)
      super
    end

    def unzip(filename)
      raise ArgumentError, 'You must inform the filename' if filename.nil?

      entries = {}
      puts "Unziping #{filename}"
      Zip::File.open(filename) do |zip_file|
        # Iterate over every file inside the ZIP archive
        zip_file.each do |entry|
          puts "Saving #{entry.name} content in memory"
          # Read into memory
          entries[entry.name] = entry.get_input_stream.read
          begin
            yield entry.name, entry.get_input_stream.read
          end
        end

        return entries
      end
    end

    def extract_files
      super(HTTPExtractor::FileExtractor::ZIP)
    end

  end

end
