Rails.application.routes.draw do 
  get '/oauth/' => 'oauth#start'
  get '/oauth/code' => 'oauth#oncode'
end
