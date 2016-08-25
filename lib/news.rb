require 'redis'

class News

	REDIS_KEY = "NEWS_XML"
	@client = Redis.new
	
	class << self
		def save(news)
			puts "Adding news to Redis list #{REDIS_KEY}"
			# Using sadd to add member to the set stored at key. 
			# Specified members that are already a member of this set are ignored.
			# http://redis.io/commands/sadd
			added = @client.sadd(REDIS_KEY, news)
			puts "News added? ", added
			return added
		end

		def find_all
			@client.smembers(REDIS_KEY)
		end
	end

end