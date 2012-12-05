Crossdic::Application.routes.draw do
  get "/search/:query" => 'search#query'
end
