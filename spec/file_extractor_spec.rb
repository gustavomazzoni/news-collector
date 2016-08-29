require 'spec_helper'
 
describe HTTPExtractor::FileExtractor do
	before :all do
		url = "http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts"
		@file_extractor = HTTPExtractor::FileExtractor.new(url)
	end

	describe "#new" do
	    it "raise an ArgumentException if parameter is not passed" do
	    	begin
	    		fe = HTTPExtractor::FileExtractor.new
	    	rescue Exception => e
	    		expect(e).to be_an_instance_of ArgumentError
	    	end
	    end
	end

	describe "#extract_files" do
	    it "returns a Hash with the key being the zip filename and the value the link for the file" do
      		result = @file_extractor.extract_files
      		expect(result).to be_an_instance_of Hash
      		# get first element from hash result
      		key, value = result.first
      		# check if key has a string with .zip at the end
      		expect(key =~ HTTPExtractor::FileExtractor::ZIP).to be > 0
      		# check if value has a string with .zip at the end
      		expect(value =~ HTTPExtractor::FileExtractor::ZIP).to be > 0
	    end
	end
 
end