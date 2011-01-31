require 'mongo'
require 'config.rb'
require 'twitter'

class TweetArchiver
  def initialize(tag)
    connection = Mongo::Connection.new
    db = connection[DATABASE_NAME]
    @tweets = db[COLLECTION_NAME]
    
    @tweets.create_index([['id', 1]], :unique => true)
    @tweets.create_index([['tags', 1]], ['id', -1])
    
    @tag = tag
  end
  
  def save_tweets_for(term)
    Twitter::Search.new.containing(term).each do |tweet|
      @tweets_found ||= 0
      @tweets_found += 1
      tweet_with_tag = tweet.to_hash.merge!({"tags" => [term]})
      @tweets.save(tweet_with_tag)
    end
    
  end
end