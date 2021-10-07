require 'sinatra'
require 'digest'

get '/' do
  redirect to('/files/'), 302
end

# Responds 200 with a JSON body containing a sorted list of valid SHA256 
# digests in sorted order (lexicographically ascending).
get '/files/' do
  require 'google/cloud/storage'
  storage = Google::Cloud::Storage.new(project_id: 'cs291a')
  bucket = storage.bucket 'cs291project2', skip_lookup: true

  files = bucket.files
  list = []
  files.all do |file|
    if(file.name[2] != "/" || file.name[5] != "/" || file.name.length() != 66)

    else

      name = file.name[0,2] + file.name[3,2] + file.name[6,64 - 4]

      hex = true
      # name.chars.each do |digit|
      #   hex = false unless digit.match(/^[0-9a-f]+$/i)
      # end

      name.each_byte do |c|
        if (c > 96 && c < 123) || (c > 47 && c < 58)

        else
          hex = false
        end
      end
      # for letter in file.name
      #   if letter == /^[0-9a-f]+$/i
      #     check = 0
      #   else
      #     check = 0
      #   end

      if hex == true
        list.push(name)
      else 

      end 
    end
  end

  list.sort
  "#{list}"

end

# On success, respond 200 and:
  # the Content-Type header should be set to that provided when the file was uploaded
  # the body should contain the contents of the file
# Respond 404 if there is no file corresponding to DIGEST.
# Respond 422 if DIGEST is not a valid SHA256 hex digest.
get '/files/*' do
  require 'pp'
  PP.pp request

  filename = params['splat'][0].downcase
  "#{filename}\n"

  if(filename.length() == 64)
    response.status = 404
    path = filename[0,2] + "/" + filename[2,2] + "/" + filename[4, 64 - 4]

    require 'google/cloud/storage'
    storage = Google::Cloud::Storage.new(project_id: 'cs291a')
    bucket = storage.bucket 'cs291project2', skip_lookup: true

    files = bucket.files
    list = []
    file_content = ""
    files.all do |f|
      if(f.name.eql?(path))
        response.status = 200
        downloaded = f.download
        downloaded.rewind
        file_content = downloaded.read 
        # response.content = File.ftype(f.name)
        # downloaded.content
      else
  
      end
    end

    if response.status != 200
      response.status = 404
    else
      "#{file_content}\n"
    end

    
  else
    response.status = 422
  end

end

# On success, respond 201 with a JSON body that encompasses the uploaded file’s hex digest
# Respond 409 if a file with the same SHA256 hex digest has already been uploaded.
# Respond 422 if:
  # there isn’t a file provided as the file parameter
  # the provided file is more than 1MB in size

post '/files/' do 
  require 'pp'
  PP.pp request
  PP.pp response
  
  filename = params['file']['tempfile']

  if filename == nil
    response.status = 422
  else
    begin
      file = File.open(filename)
    rescue Exception, Errno::ENOENT
      response.status = 422
    end 

    if File.size(filename) >= 1024 * 1024 * 1024 || response.status == 422
      response.status = 422
    else

      sha256 = Digest::SHA256.new
      sha256 = Digest::SHA256.file file
      path = sha256.hexdigest[0,2] + "/" + sha256.hexdigest[2,2] + "/" + sha256.hexdigest[4, 64 - 4]

      require 'google/cloud/storage'
      storage = Google::Cloud::Storage.new(project_id: 'cs291a')
      bucket = storage.bucket 'cs291project2', skip_lookup: true

      files = bucket.files
      list = []
      files.all do |f|
        if(f.name.eql?(path))
          response.status = 409
        else
    
        end
      end

      if response.status == 409
        "ALREADY UPLOADED\n\n"
      else
        bucket.create_file file, path
        response.status = 201
        "{\"uploaded\": \"#{sha256.hexdigest}\"}\n"

      end

    end

  end

end

delete '/files/*' do
  require 'pp'
  PP.pp request

  filename = params['splat'][0].downcase
  "#{filename}\n"
  
  if(filename.length() == 64)
    path = filename[0,2] + "/" + filename[2,2] + "/" + filename[4, 64 - 4]

    require 'google/cloud/storage'
    storage = Google::Cloud::Storage.new(project_id: 'cs291a')
    bucket = storage.bucket 'cs291project2', skip_lookup: true

    files = bucket.files
    list = []
    file_content = ""
    files.all do |f|
      if(f.name.eql?(path))
        f.delete
        response.status = 200
      else
  
      end
    end

  else
    response.status = 422
  end
end