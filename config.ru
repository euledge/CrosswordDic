require 'bundler'
Bundler.require

require './app'
require ::File.expand_path('../config/environment',  __FILE__)
run App
