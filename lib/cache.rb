module Toggle
	class Cache
		@@storage = {}
		@@expiration_time = nil

		def initialize(expiration_time=10)
			@@expiration_time = expiration_time
		end
		
		def fetch(key)
			if @@storage.key?(key) and @@storage[key][:expiration_time] > Time.now.to_i 
				p "fetch from cache - TTL #{@@expiration_time}sec"				
				return Toggle::Feature.new(key, @@storage[key][:value])
			else
				p "not in the cache"
				return nil
			end						
		end

		def set(key, state, expiration_time = @@expiration_time)
			@@storage[key] = {value: state, expiration_time: Time.now.to_i + expiration_time}
			return Toggle::Feature.new(key, state)
		end

		def get_expiration_time
			return @@expiration_time
		end
	end
end