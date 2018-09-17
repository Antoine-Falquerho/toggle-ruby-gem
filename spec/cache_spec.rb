require 'spec_helper'
require 'toggle'


describe Toggle::Cache do
	describe "#fetch" do
		context "with an existing feature" do
			it "should return the feature's cache" do
				cache = Toggle::Cache.new
				cache.set("featureA", true)
				feature = cache.fetch("featureA")
				expect(feature.name).to eql("featureA")
				expect(feature.state).to eql(true)
			end
		end 

		context "with an existing feature" do
			it "should return nil if the feature is not in the cache" do
				cache = Toggle::Cache.new				
				feature = cache.fetch("featureA")
				expect(feature.name).to eql("featureA")
				expect(feature.state).to eql(true)
			end
		end

		context "when passing an expiration time" do
			it "should change the default TTL to the argument" do
				cache = Toggle::Cache.new(15)
				expect(cache.get_expiration_time).to eql(15)
			end
		end
	end
end
