#!/usr/bin/env ruby
#
# Ruby script to extract zip files from individual URL via HTTP
# unzip each one and save the XML content in Redis List
#
# Author: Gustavo Mazzoni

require './lib/zip_extractor'
require './lib/news'

def main
  url = ARGV.first || "http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts"
  threads_number = ARGV[1].to_i

  if threads_number < 1
    threads_number = 10
  end

  zip_extractor = HTTPExtractor::ZipExtractor.new(url)
  # extract all zip links from page
  ziplinks = zip_extractor.extract_files

  # download all zip files
  zip_extractor.download_files(ziplinks, threads_number) do |zipname|
    # unzip each zipfile
    zip_extractor.unzip(zipname) do |xmlname, content|
      # save XML content to 'NEWS_XML' redis list if it not already exists
      News.save(content)
    end
  end

  puts "SUCCESS - News extracted and saved"
end


if __FILE__ == $0
  usage = <<-EOU
usage: ruby #{File.basename($0)} http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/ 50
  The first argument is the URL where the ZIP files will be extracted.
  The second argument is the number of threads to perform parallel execution.
  * None of them is mandatory
  EOU

  abort usage if ARGV.length > 2

  main

end
