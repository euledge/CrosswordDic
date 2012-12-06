# coding:utf-8
require 'redis'
require 'active_support'

unless ARGV.length==1 then
  p "Usage: search_redis.rb 検索キー"
  exit 1
end

redis = Redis.new
redis.ping

word=ARGV[0]

keys = Array.new
(1..word.size).each do |i|
  keys << "#{i}:#{word[i-1]}" unless word[i-1] == '＊'
end
keys << "#{word.size+1}:＄"
words=redis.sinter(*keys)
words.each do |w|
  value = ActiveSupport::JSON.decode(w)
  p "読み:#{value['yomi']} 単語:#{value['word']}"
end
redis.quit
