Crossdic::Application.routes.draw do
  get "/search/:query(.:format)" => 'search#query'
end
