require './config'
require './TweetArchiver'

TAGS.each do |tag|
  archive = TweetArchiver.new(tag)
  archive.update
end