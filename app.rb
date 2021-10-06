require 'sinatra'

get '/' do
  redirect to('/files/')
  "HTTP/1.1 302 Found\n"
  "location: https://abbywysopal-66egyap56q-uc.a.run.app/files/\n"
end

get '/files/' do
  "Hello World!!\n"
end

get '/files/*.*' do |path, ext|
  [path, ext] # => ["path/to/file", "xml"]
end

post '/' do
  require 'pp'
  PP.pp request
  "POST\n"
end
