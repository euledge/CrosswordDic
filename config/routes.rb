Crossdic::Application.routes.draw do
  get "/search/" => 'search#query'
  get "/search/:query" => 'search#query'
end
