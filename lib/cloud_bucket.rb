require 'rubygems'
require 'aws/s3'

class CloudBucket
  @@aws_bucket = AWS::S3::Bucket
  
  KID = ENV['AMAZON_ACCESS_KEY_ID']
  SKEY = ENV['AMAZON_SECRET_ACCESS_KEY']
  
  def self.connect(kid, skey)
    AWS::S3::Base.establish_connection!(
        :access_key_id     => kid,
        :secret_access_key => skey
      )
      
    # raises error for bad connection
    AWS::S3::Service.buckets
  end
  
  def initialize( name )
    @name = name
    @@aws_bucket.create(@name)
    @bucket = @@aws_bucket.find(@name)
  end
  
  def objects
    objects = @bucket.objects
    objects.collect {|obj| obj}
  end
  
  def add(file, name)
    name ||= File.basename(file)
    AWS::S3::S3Object.store(name, open(file), @name)
  end
  
  def <<(file)
    name = File.basename(file)
    AWS::S3::S3Object.store(name, open(file), @name)
  end
  
  def self.[](name)
    CloudBucket.new(name)
  end
  
  def self.list
    @@aws_bucket.list.collect { |b| b.name }
  end
  
  def self.delete(name, force = false)
    @@aws_bucket.delete(name, :force => force)
  end
  
  protected
  def self.disconnect
    AWS::S3::Base.disconnect!
  end
  
  def self.connected?
    AWS::S3::Base.connected?
  end
  
  CloudBucket.connect(KID, SKEY) unless CloudBucket.connected?
end