require 'spec_helper'
require 'toggle'


describe Toggle::Feature do
	describe "#fetch" do
		context "should have a name and a state" do
			it "should be able to create a new feature and get the attributes" do
				feature = Toggle::Feature.new("featureA", true)

				expect(feature.name).to eql("featureA")
				expect(feature.state).to eql(true)
				
			end
		end 

		context "with an existing feature" do
			it "should return an error if the state is not a boolean" do
				expect{Toggle::Feature.new("featureA", "something but not a boolean")}.to raise_error("state is not a Boolean")
			end
		end
	end
end
