#!/usr/bin/ruby

require 'twitter'
require 'dotenv'
require 'pry'
require 'time'

Dotenv.load

def collect_with_max_id(collection=[], max_id=nil, count = 0 &block)
    return collection if collection.all? { |tweet| tweet.created_at < DateTime.new(2017, 12, 1) }
    response = yield(max_id)
    collection += response.to_a
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, count + 1, &block)
end

twitter_consumer_key = ENV['TWITTER_CONSUMER_KEY']
twitter_consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
twitter_access_token = ENV['TWITTER_ACCESS_TOKEN']
twitter_access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']

client = Twitter::REST::Client.new do |config|
    config.consumer_key        = twitter_consumer_key
    config.consumer_secret     = twitter_consumer_secret
    config.access_token        = twitter_access_token
    config.access_token_secret = twitter_access_token_secret
end

def client.aggregate_socionoel
    collect_with_max_id do |max_id|
        options = { count: 100, result_type: 'recent', tweet_mode: 'extended' }
        options[:max_id] = max_id unless max_id.nil?
        res = []
        self.search('#SocioNoel', options).each do |tweet|
            res.push tweet
        end
        res
    end
end

results = client.aggregate_socionoel.map { |tweet| {
    full_text: tweet.full_text,
    text: tweet.text,
    uri: tweet.uri,
    user_name: tweet.user.name,
    user_screen_name: tweet.user.screen_name,
    created_at: tweet.created_at,
} }
File.open("tweets.json", 'w') { |file| file.write(results.to_json) }

puts 'done'

# client.search("#socionoel", result_type: "mixed", count: 100).take(3).each do |tweet|
#     pry tweet
#     puts tweet.inspect
# end
