require 'spec_helper'
require 'redis'
 
describe News do
	before :all do
		XML_CONTENT = "!!!<TEST>!!!"
		@client = Redis.new
		@client.srem(News::REDIS_KEY, XML_CONTENT)
	end

	describe "#save" do
	    it "takes one parameter (XML content) and returns true for new member saved to Redis list" do
      		result = News.save(XML_CONTENT)
      		expect(result).to eq true
	    end

	    it "takes one parameter (XML content) and returns false for already existing member in Redis list" do
	        result = News.save(XML_CONTENT)
      		expect(result).to eq false
	    end
	end
 
end