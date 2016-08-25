require 'open-uri'
require 'net/http'
require 'uri'
require 'xml/to/json'

module HTTPExtractor

  class FileExtractor

    ZIP = /\.(zip)$/i

    def initialize(url = nil)
      raise ArgumentError, 'You must inform an URL' if url.nil?

      @url = url
    end

    def download_files(links = @links, threads_count = 10)
      queue = Queue.new
      threads = []

      # add work to the queue
      links.each { |key, value| queue << key }

      puts "Starting HTTP download at: " + @url
      uri = URI(@url)

      threads_count.times do
        threads << Thread.new do
          begin
            Net::HTTP.start(uri.host, uri.port) do |http|
              # loop until there are no more things to do
              until queue.empty?
                # pop with the non-blocking flag set, this raises
                # an exception if the queue is empty, in which case
                # work_unit will be set to nil
                filename = queue.pop(true) rescue nil
                if filename
                  # do work
                  file_uri = URI(links[filename])
                  puts "Downloading file: " + file_uri.to_s
                  request = Net::HTTP::Get.new(file_uri)
                  resp = http.request request do |response|
                    open filename, 'w' do |io|
                      response.read_body do |chunk|
                        io.write chunk
                      end
                    end
                  end
                  puts "Stored download as " + filename + "."
                  begin
                    yield filename
                  end
                end
              end
            end
          rescue Exception => e
            puts "=> Exception: '#{e}'. Skipping download."
            return
          end
        end
      end

      # wait until all threads have completed processing
      threads.each(&:join)
    end

    def extract_files(type = ZIP)
      @links = {}
      
      doc = Nokogiri::HTML(open(@url))
      doc.xpath('//*[@href]').select { |a| a['href'] =~ type }.each { |link| @links[link['href']] = @url + '/' + link['href'] }
      return @links
    end

  end

end

