#!/usr/bin/env ruby
require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

search_options = {
  result_type: "recent"
}

found_snickerdoodle_tweet = false

client.search("@rainorshineYVR+snickerdoodle -rt", search_options).each do |tweet|
  if tweet.user.screen_name != "SnickerdooBot"
    begin
      client.retweet!(tweet)
      client.favorite(tweet)
      found_snickerdoodle_tweet = true
      puts 'snickerdoodle tweet: ' + tweet.text
    rescue
     puts 'rescued from: ' + tweet.text
    end
  end
end

if !found_snickerdoodle_tweet
  client.search("@rainorshineYVR -rt", search_options).each do |tweet|
    if tweet.user.screen_name != "SnickerdooBot" && !tweet.reply?
      one_day_ago = Time.now - (60 * 60 * 24)
      tweet_time  = tweet.created_at - (60 * 60 * 7)
      if tweet_time > one_day_ago

        begin
          client.update!("Rain or Shine Ice Cream needs to bring back snickerdoodle flavour!🍦👏 #BringBackSnickerdoodle " + tweet.url)
          client.favorite(tweet)
          puts 'tweet: ' + tweet.text
        rescue
          puts 'rescued from: ' + tweet.text
        end

      end
    end
  end
end

client.update("Bring👏Back👏Snickerdoodle👏Ice👏Cream👏 #BringBackSnickerdoodle 🍦 #rainorshineYVR 🍦")