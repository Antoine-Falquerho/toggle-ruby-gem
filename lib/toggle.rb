require 'faraday'
require 'json'
load 'lib/cache.rb'
load 'lib/feature.rb'

module Toggle
	class Client		
		expiration_time = 10
		@host = nil


		def initialize(host, expiration_time = 10)	
			@host = host	
			@expiration_time = expiration_time
			@conn = Faraday.new(:url => host)		
		end

		def get(key)
			feature = cache.fetch(key)
			if feature				
				return feature
			else
				response = @conn.get('/features/' + key)				
				if response.status == 200										
					state = JSON.parse(response.body)["state"]					
					cache.set(key, state)
					feature = Toggle::Feature.new(key, state)
					return feature
				else
					return nil
				end
			end
		end

		def cache
			@cache ||= Cache.new(@expiration_time)
		end

		def set(key, state)
			json = { 'key' => key, 'state' => state}
			response = @conn.post '/features', json.to_json, { 'Content-Type' => 'application/json' }			

			if response.status == 200
				cache.set(key, state)
				feature = Toggle::Feature.new(JSON.parse(response.body)["key"], JSON.parse(response.body)["state"])				
				return feature
			else
				raise "An error has occured: #{response.body}"
			end
		end
	end
end