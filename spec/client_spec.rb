require 'spec_helper'
require 'toggle'


describe Toggle::Client do
	before(:all) do    
		#clear the cache
	end

	describe "#get" do
		context "with an existing feature" do
			it "should return the state" do
				f = Toggle::Client.new("http://mock_service:8080")
				
				stub_request(:get, "http://mock_service:8080/features/featureA").
				with(
				headers: {
					'Accept'=>'*/*',
					'User-Agent'=>'Faraday v0.15.2'
				}).
				to_return(status: 200, body: "{\"name\":\"featureA\",\"state\":true}", headers: {})
								
				expect(f.get("featureA").state).to eql(true)
			end
		end 

		context "with an existing feature" do
			it "should return the state in the cache if we requested the feature less than 10 sec ago " do
				f = Toggle::Client.new("http://mock_service:8080")
				
				stub = stub_request(:get, "http://mock_service:8080/features/featureB").
				with(
				headers: {
					'Accept'=>'*/*',
					'User-Agent'=>'Faraday v0.15.2'
				}).
				to_return(status: 200, body: "{\"name\":\"featureB\",\"state\":true}", headers: {})

				#first call for featureB
				featureB = f.get("featureB")
				expect(featureB.name).to eql("featureB")
				expect(featureB.state).to eql(true)

				#second call for featureB
				expect(f.get("featureB").state).to eql(true)

				# make sure we only call the service once
				# the second time, it should use the cache
				expect(stub).to have_been_made.times(1) 
			end
		end 

		context "with an non existing feature" do
			it "should return nil" do
				f = Toggle::Client.new("http://mock_service:8080")
				
				stub_request(:get, "http://mock_service:8080/features/featureC").
				with(
				headers: {
					'Accept'=>'*/*',
					'User-Agent'=>'Faraday v0.15.2'
				}).
				to_return(status: 404, body: "", headers: {})
				
				featureC = f.get("featureC")
				expect(featureC).to eql(nil)
			end
		end 
	end

	describe "#set" do
		context "create a new feature" do
			it "should create and return a new feature" do
				f = Toggle::Client.new("http://mock_service:8080")
				
				stub_request(:post, "http://mock_service:8080/features").
				with(
				headers: {
					'Accept'=>'*/*',
					'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
					'User-Agent'=>'Faraday v0.15.2'
				}).
				to_return(status: 200, body: "{\"name\":\"featureA\",\"state\":true}", headers: {})

				mock_featureD = Toggle::Feature.new("featureD", true)
				expect(mock_featureD.name).to eql("featureD")
				expect(mock_featureD.state).to eql(true)
			end
		end 

		context "create a new feature and the service get a wrong payload" do
			it "should raise an error" do
				f = Toggle::Client.new("http://mock_service:8080")
				
				stub_request(:post, "http://mock_service:8080/features").
				with(
				headers: {
					'Accept'=>'*/*',
					'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
					'User-Agent'=>'Faraday v0.15.2'
				}).
				to_return(status: 400, body: "", headers: {})				

				expect{f.set("featureA", true)}.to raise_error("An error has occured: ")

			end
		end 
	end
end