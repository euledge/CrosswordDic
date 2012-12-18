# coding:utf-8
require 'redis'

class SearchController < ApplicationController
  before_filter :redis_authentication

  def query
    @query_word=params[:query]
    keys = get_keys(@query_word)

    respond_to do |format|
      format.html {
        @words=$redis.sinter(*keys)
        @words.map!{|value| ActiveSupport::JSON.decode(value)}
      }
      format.json {
        render :json => $redis.sinter(*keys)
      }
    end
  end
private
  # 検索キーに変換する
  def get_keys(query_word)
    keys = Array.new
    (1..query_word.size).each do |i|
      keys << "#{i}:#{query_word[i-1]}" unless query_word[i-1] == '＊'
    end
    keys << "#{query_word.size+1}:＄"
  end

  def redis_authentication
    if Rails.env == 'production'
      $env = ActiveSupport::JSON.decode(File.read('/home/dotcloud/environment.json'))
      $redis = Redis.new(host: "#{$env['DOTCLOUD_DATA_REDIS_HOST']}" , port: "#{$env['DOTCLOUD_DATA_REDIS_PORT']}")
      $redis.AUTH("#{$env['DOTCLOUD_DATA_REDIS_PASSWORD']}")
    else
      $redis = Redis.new
    end
    $redis.ping
  end
end
