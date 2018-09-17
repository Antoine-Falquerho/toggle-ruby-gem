# Toggle ruby gem

## Build Gem

	gem build toggle.gemspec
	gem install ./toggle-0.0.0.gem


### Run tests

	bundle exec rspec

### Test Gem

```ruby
irb
require 'toggle'
f = Feature.new("http://localhost:8080")
f.get("featureA")
f.set("featureA", true)
f.get("featureA")
f.get("featureA")
```

## Client Documentation

Feature Object
------

Feature has two attributes, _name_ and a _state_

	feature_name = "featureA"
	state = true
	feature = Feature.new(feature_name, state)

*Get Name:*

	feature.name

*Get State:*

	feature.state

Create Client and Get a Feature
------

	host = "http://localhost:8080"
	ttl = 10
	client = Feature.new(host, ttl)
	feature_name = "featureA"
	client.get(feature_name)

*it returns a Feature Object*

Create Client and Set a Feature
------
	host = "http://localhost:8080"
	ttl = 10
	feature_name = "featureA"
	state = true
	client = Feature.new(host, ttl)
	client.set(feature_name, state)

*it returns a Feature Object*

Caching
------
	Using ruby Hash to store the previous requested features with a TTL of 10 sec by default
	The TTL can be change while creating a new Client

### Service API Endpoints

Get Feature
------

	curl -X GET http://localhost:8080/features/featureA

Set Feature
------

	curl -X POST \
	http://localhost:8080/features \
	-H 'Content-Type: application/json' \
	-d '{
	"key": "featureA",
	"state": true
	}'


##### Potential improvements

	1. Build _/enable_ and _/disable_ endpoints instead of having _POST_ endpoint
	2. Add an endpoint to the service to load all the features in the client
	3. Be careful with the current implementation since there is no limit on how many items we cache
		Could use a queue with most recent used features and only keep a small number in the cache
	4. A local redis could be interesting but seems over engineering for a small service like that
		The service should have a redis instead