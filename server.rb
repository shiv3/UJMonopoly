require 'sinatra'
require 'grape'

set :bind, '0.0.0.0'

class API < Grape::API
  get :hello do
    { hello: "world" }
  end
end

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end

use Rack::Session::Cookie
ruby Rack::Cascade.new [API, Web]
