#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'awesome_print'
require 'yaml'
class TweetCrawler
  def initialize
    @url        = "https://twitter.com/esconsult1/status/730784313688637440"
    @user_agent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7"
    @array      = []
  end
    attr_accessor :array, :url

  def get_tweet_info(url)
    page =  Nokogiri::HTML(open(url,'User-Agent' => @user_agent), nil, "UTF-8")
    tweet_hash = {}
    #tweet_hash[tweet_uid]
    tweet_hash["author_icon"]     = page.search('img.avatar.js-action-profile-avatar').first['src'] 
    tweet_hash["athor_name"]      = page.search('strong.fullname.js-action-profile-name.show-popup-with-id').first.text 
    tweet_hash["aouthor_login"]   = page.search('span.username.js-action-profile-name').first.text 
    tweet_hash["tweet_conent"]    = page.search('p.TweetTextSize.js-tweet-text.tweet-text').first.text 
    tweet_hash["date"]	          = page.search('span.metadata').first.text 
    tweet_hash["next_tweet"]      =	page.search('div.TweetArrows a').first.attributes.first.last.value.split("/").last 
    tweet_hash
  end


  def collect_tweets(x)
    arr = [] 
    url = "https://twitter.com/esconsult1/status/730784313688637440"
    1.upto(10) do |i| 
      puts "#{i}    #{url}"
      tweet = get_tweet_info(url)
      @array << tweet
      ap tweet
      puts "---------------------------------------------------------------------"
      url = "https://twitter.com/esconsult1/status/#{tweet['next_tweet']}"
      
    end
   arr
  end

end

spider = TweetCrawler.new
spider.collect_tweets(10)

File.open("test.yml", 'w') { |f| f << @array.to_yaml }





