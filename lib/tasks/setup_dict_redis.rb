# coding:utf-8

require 'redis'
require 'active_support'

def make_crossword(pronounce, word)
  crosswords = Array.new
  (1..pronounce.size).each do |i|
    str = "#{i}:#{pronounce[i-1]}"
    crosswords << [str, pronounce, word]
  end
  str = "#{pronounce.size+1}:＄"
  crosswords << [str, pronounce, word]
  crosswords
end

def add_dictionary_to_redis(redis, pronounce, word)
   crosswords = make_crossword(pronounce, word)
   crosswords.each do |words|
     #p "{#{words[0]}  {#{words[1]}:#{words[2]}}}"
     value = {"yomi" => words[1],  "word" => words[2]}
     redis.sadd(words[0], ActiveSupport::JSON.encode(value))
   end
end

TABLE={
   "ァ" => "ア",
   "ィ" => "イ",
   "ゥ" => "ウ",
   "ェ" => "エ",
   "ォ" => "オ",
   "ヵ" => "カ",
   "ヶ" => "ケ",
   "ッ" => "ツ",
   "ャ" => "ヤ",
   "ュ" => "ユ",
   "ョ" => "ヨ",
   "ヮ" => "ワ"
}

def toupper_kana(str)
  str.gsub(/[#{TABLE.keys.join("")}]/){|ch| TABLE[ch]}
end


##### main routin #####
unless ARGV.length==1 then
  p "Usage: setup_dict_redis.rb filename"
  exit 1
end

redis = Redis.new
redis.ping
redis.flushdb

filename=ARGV[0]
File.foreach(filename) do |line|
  fields = line.split(",")
  unless /記号/ =~ fields[4] then
    yomi=fields[11].gsub(/[#{TABLE.keys.join("")}]/){|ch| TABLE[ch]}
    if 1<fields[11].size && fields[11].size<9 then
      add_dictionary_to_redis(redis, "#{toupper_kana(fields[11])}","#{fields[0]}")
    end
  end
end
redis.save
info = redis.info
p info["db0"]
redis.quit

