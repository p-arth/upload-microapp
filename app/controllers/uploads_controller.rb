require 'aws-sdk'
require 'aws-sdk-s3'
require 'json'

class UploadsController < ApplicationController

  def new
  end

  def create

    urlOAuth = 'https://as.api.iledefrance-mobilites.fr/api/oauth/token'
    client_id = ENV['CLIENT_ID']
    client_secret = ENV['CLIENT_SECRET']

    data = {
      grant_type: 'client_credentials',
      scope: 'read-data',
      client_id: client_id,
      client_secret: client_secret
    }

    result = RestClient.post( urlOAuth, data )
    result = JSON.parse(result)

    token = result['access_token']
    # binding.pry

    api_url = 'https://traffic.api.iledefrance-mobilites.fr/v1/tr-global/estimated-timetable'

    api_headers = {
      'Accept-Encoding': 'gzip',
      'Authorization': 'Bearer ' + token
    }

    final_result = RestClient.get( api_url, headers = api_headers )
    # binding.pry
    json_data = JSON.parse(ActiveSupport::Gzip.decompress(final_result))
    # binding.pry

    time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    file_name = time

    File.write("public/#{file_name}.json", json_data)

    # @response = Response.create!(response_params)
    # binding.pry
    # @response.json_data.attach(params[:json_file])
    # binding.pry
    file_location = File.open("public/#{file_name}.json")
        
    # @response.json_file.attach(io: file, filename: "#{file_name}.json", content_type: 'application/json')
    # @response.json_file.attached?
    # binding.pry

    # @response
    
    # if @response.save
    #   render json: @response, status: :created, location: @response
    # else
    #   render json: @response.errors, status: :unprocessable_entity
    # end

    profile_name = 'p-arth'
    region = ENV['AWS_REGION']
    bucket = ENV['S3_BUCKET']

    s3 = Aws::S3::Client.new(profile: profile_name, region: region)

    s3.put_object(bucket: bucket, key: "#{file_name}.json", body: file_location)


    # # Make an object in your bucket for your upload
    # obj = ENV['S3_BUCKET'].objects[file_name]

    # # Upload the file
    # obj.write(
    #   file: file_location,
    #   acl: :public_read
    # )

    # Create an object for the upload
    # @upload = Upload.new(
    # 		url: obj.public_url,
		#     name: obj.key
    # 	)

    # # Save the upload
    # if @upload.save
    #   puts 'File successfully uploaded'
    # else
    #   puts 'There was an error'
    #   # render :new
    # end
  end

  def index
  end

end
