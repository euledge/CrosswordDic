# coding:utf-8
require 'redis'

class SearchController < ApplicationController
  def query
    @query_word=params[:query]

    keys = get_keys(@query_word)

    respond_to do |format|
      format.html {
        @words=REDIS.sinter(*keys)
        @words.map!{|value| ActiveSupport::JSON.decode(value)}
      }
      format.json {
        render :json => REDIS.sinter(*keys)
      }
    end
  end

  # 検索キーに変換する
  def get_keys(query_word)
    keys = Array.new
    (1..query_word.size).each do |i|
      keys << "#{i}:#{query_word[i-1]}" unless query_word[i-1] == '＊'
    end
    keys << "#{query_word.size+1}:＄"
  end
end
