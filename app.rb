require 'sinatra'
require 'digest'
# require 'google/cloud/storage'
# storage = Google::Cloud::Storage.new(project_id: 'cs291a')
# bucket = storage.bucket 'cs291project2', skip_lookup: true

all_files = Array.new
length = 0

get '/' do
  redirect to('/files/'), 302
end

get '/files/' do
  "Hello World!!\n"
  [path, ext] # => ["path/to/file", "xml"]
  sha256 = Digest::SHA256.file path
  sha256.hexdigest
end

get '/files/*.*' do |path, ext|
  [path, ext] # => ["path/to/file", "xml"]

  sha256 = Digest::SHA256.file path
  sha256.hexdigest
end

post '/files/' do 
  require 'pp'
  PP.pp request
  
  filename = params['file']['filename']
  "#{filename}"

  # if filename == nil
  #   # halt 422
  #   "422"
  # else
  #   # "{uploaded: #{sha256.hexdigest}}"
  #   # File.read(filename, "r")
  #   sha256 = Digest::SHA256.new
  #   sha256 = Digest::SHA256.file filename
  #   all_files << sha256.hexdigest
  #   "uploaded: #{sha256.hexdigest}\n"
  # end

end

# post '/' do
#   require 'pp'
#   PP.pp request
#   "POST\n"
# end

# delete '/' do
#   .. annihilate something ..
# end