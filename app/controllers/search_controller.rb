# coding:utf-8
require 'redis'

class SearchController < ApplicationController
  def query
    query_word=params[:query]

    # 検索キーに変換する
    keys = Array.new
    (1..query_word.size).each do |i|
      keys << "#{i}:#{query_word[i-1]}" unless query_word[i-1] == '＊'
    end
    keys << "#{query_word.size+1}:＄"

    @words=REDIS.sinter(*keys)
  end
end
