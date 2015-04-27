require 'uri'
require 'open-uri'
uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:url => uri)