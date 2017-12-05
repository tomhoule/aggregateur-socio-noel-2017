#!/usr/bin/ruby

require 'json'
require 'time'

START_DATE = Date.new(2017, 12, 1)

tweets = JSON.parse File.read("tweets.json")

tweets.each do |uri, tweet|
    tweet['created_at'] = DateTime.parse(tweet['created_at'])
end

tweets =  tweets.
    values.
    sort { |a,b| a['created_at'] <=> b['created_at'] }.
    group_by { |tweet| tweet['created_at'].to_date }

File.open("tweets.md", 'w') do |file|
    file.write("# SocioNoel 2017")
    tweets.each do |date, tweets|
        next if tweets.empty? || date < START_DATE
        file.write("\n\n## #{date}\n\n")

        tweets.each do |tweet|
            next if tweet['full_text'].match(/^RT/)
            text = tweet['full_text'].gsub(/^/, '> ')
            file.write("\n---\n\n#{tweet['user_name']} (#{tweet['user_screen_name']})\n#{text}\n")
        end
    end
end

puts 'done'
