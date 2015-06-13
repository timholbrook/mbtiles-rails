# MBTiles-Rails

MBTiles reading and writing library. Based on MBTiles-ruby using the MBTiles specification
version 1.1.

[See MBTiles-ruby](https://github.com/etehtsea/mbtiles-ruby).
[See MBTiles-spec](https://github.com/mapbox/mbtiles-spec).

## Installation

Add this line to your application's Gemfile:

    gem 'mbtiles', :git => "https://github.com/etehtsea/mbtiles-rails"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mbtiles

## Usage

```ruby
require 'mbtiles'

# tilebox_url = 'http://tiles.tld/osm'
fetcher = MBTiles::ParallelFetcher.new(tilebox_url)
coords = [59.950675,30.291254,59.949888,30.292638]
path = '/tmp/sample.mbtiles'
zoom_levels = [0, 10]
access_token = '?access_token=ergearbesbesioadvau099we324jq34gnq3wgq34g3.4gq34hgq3rbh'

MBTiles::Writer.new(coords, fetcher, zoom_levels, path, access_token).save
```

There is lack of documentation at the moment, so for additional info please
[see specs](https://github.com/etehtsea/mbtiles-ruby/tree/master/spec).

## Development
For development needs you can `mock!` all requests to external source.

``` ruby
fetcher = MBTiles::ParallelFetcher.new("http://#{tilebox_url}", 60)
fetcher.mock! # unless YOUR_ENV == 'production'
