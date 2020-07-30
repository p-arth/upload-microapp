require 'aws-sdk'
require 'aws-sdk-s3'
require 'json'

Aws.config.update({
    region: ENV['AWS_REGION'],
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    # :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    # :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
})

profile_name = 'p-arth'
region = ENV['AWS_REGION']
bucket = ENV['S3_BUCKET']

s3 = Aws::S3::Client.new(profile: profile_name, region: region)

# s3 = Aws::S3
# S3_BUCKET = Aws::S3::Client.new.buckets[ENV['S3_BUCKET']]