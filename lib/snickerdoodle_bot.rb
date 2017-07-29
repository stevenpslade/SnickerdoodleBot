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
one_day_ago = Time.now.utc - (60 * 60 * 24)

client.search("@rainorshineYVR+snickerdoodle -rt", search_options).each do |tweet|
  tweet_time  = tweet.created_at
  if tweet.user.screen_name != "SnickerdooBot" && tweet_time > one_day_ago
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
    tweet_time  = tweet.created_at
    if tweet.user.screen_name != "SnickerdooBot" && !tweet.reply? && tweet_time > one_day_ago
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

found_rainorshine_tweet = false
client.user_timeline("rainorshineYVR").each do |tweet|
  tweet_time  = tweet.created_at
  if !tweet.reply? && tweet_time > one_day_ago
    text = tweet.text.dup
    text.downcase!
    reply = "rainorshineYVR tweeted: "

    if text.include?("snickerdoodle") && text.include?("back")
      reply << "I see snickerdoodle and it might be back! 👏👏👏 "
    elsif text.include?("snickerdoodle")
      reply << "I see snickerdoodle 👍 but I'm not sure about the rest...🤔 #BringBackSnickerdoodle "
    else
      reply << "no mention of if snickerdoodle will be back!😞👎 #BringBackSnickerdoodle #rainorshineYVR "
    end

    puts tweet.text

    client.update(reply + tweet.url)
    found_rainorshine_tweet = true
  end
end

if !found_rainorshine_tweet
  client.update("Bring👏Back👏Snickerdoodle👏Ice👏Cream👏 #BringBackSnickerdoodle 🍦 #rainorshineYVR 🍦")
end



