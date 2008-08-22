require 'rubygems'
require 'aws/s3'
require File.join(File.dirname(__FILE__), 'bucket')

module AStore
  KID = ENV['AMAZON_ACCESS_KEY_ID']
  SKEY = ENV['AMAZON_SECRET_ACCESS_KEY']
  
  class Base
    attr_reader :aws3, :bucket, :namespace
    
    def initialize( namespace, kid = KID, skey = SKEY )
      @namespace = namespace
      @aws3 = AWS::S3
      
      AWS::S3::Base.establish_connection!(
          :access_key_id     => kid,
          :secret_access_key => skey
        )
        
      # raises error for bad connection
      @aws3::Service.buckets
      
      @aws_bucket = AWS::S3::Bucket
      @bucket = Bucket.new( @aws3, namespace )
    end
    
    def get(bucket)
      @bucket[bucket]
    end
    alias :[] :get
    
    def buckets
      @bucket.list
    end
    
    def connected?
      @aws3::Base.connected?
    end
    
    def disconnect
      @aws3::Base.disconnect!
    end
  end
end