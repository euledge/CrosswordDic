# coding: utf-8
require 'active_record'
require 'active_support'
require 'sass'

# DBの接続
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

# 辞書のモデル
class Dictionary < ActiveRecord::Base
  scope :search_for_condition, lambda{|hashes|
    conditions = nil
    hashes.each do |pair|
      pair.each do |field, val|
        if conditions.nil?
          conditions = arel_table[field].eq(val)
        else
          conditions = conditions.and(arel_table[field].eq(val))
        end
      end
    end
    where(conditions)
  }
end

# Controller
class App < Sinatra::Base

  get '/' do
  end

  # 静的ファイル
  get '/search/:file.:ext' do |file, ext|
    content_type ext
    send_file "/search/images/#{file}.#{ext}"
  end

  # JSONの時
  get '/search/:pronounce.json' do
    @query_word=params['pronounce']
    @results = query(@query_word)
    @results.to_json
  end
  # それ以外の時
  get '/search/:pronounce' do
    @query_word=params['pronounce']
    @results = query(@query_word)
    haml :index
  end
  # stylesheet.cssの時
  get '/search/css/style.css' do
    scss :'css/style'
  end

private
  def query(query_word)
    conditions = Array.new
    (1..query_word.size).each do |i|
      conditions.push  a= {c1: @query_word[i-1]} if (i==1 && @query_word[i-1] != '＊')
      conditions.push  a= {c2: @query_word[i-1]} if (i==2 && @query_word[i-1] != '＊')
      conditions.push  a= {c3: @query_word[i-1]} if (i==3 && @query_word[i-1] != '＊')
      conditions.push  a= {c4: @query_word[i-1]} if (i==4 && @query_word[i-1] != '＊')
      conditions.push  a= {c5: @query_word[i-1]} if (i==5 && @query_word[i-1] != '＊')
      conditions.push  a= {c6: @query_word[i-1]} if (i==6 && @query_word[i-1] != '＊')
      conditions.push  a= {c7: @query_word[i-1]} if (i==7 && @query_word[i-1] != '＊')
      conditions.push  a= {c8: @query_word[i-1]} if (i==8 && @query_word[i-1] != '＊')
    end
    Dictionary.search_for_condition(conditions)
  end
#
end
