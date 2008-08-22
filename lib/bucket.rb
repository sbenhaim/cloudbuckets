require 'rubygems'
require 'aws/s3'

module AStore
  class Bucket
    
    def initialize( aws3, namespace )
      @bucket = aws3::Bucket
      @service = aws3::Service
      @namespace = namespace
    end
    
    def create(name)
      @bucket.create(namespace(name))
    end
    
    alias :<< :create
    
    def[](name)
      @bucket.find(namespace(name))
    rescue AWS::S3::NoSuchBucket
      false
    end
    
    def list
      @bucket.list.collect { |b| b.name.sub(/#{@namespace}\./, '') }
    end
    
    def delete(name)
      @bucket.delete(namespace(name))
    rescue AWS::S3::NoSuchBucket
      false
    end
    
    protected
    def namespace( name )
      @namespace + '.' + name
    end
  end
end