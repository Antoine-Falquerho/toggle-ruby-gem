=begin
	A simple Feature object that has a name and a state
=end

module Toggle
	class Feature
		attr_accessor :name, :state

		def initialize(name, state)
			@name = name
			if state == true or state == false			
				@state = state
			else
				raise "state is not a Boolean"
			end
		end

	end

end
