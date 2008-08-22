require 'rubygems'
require 'spec'
require 'lib/cloud_bucket.rb'

describe CloudBucket do

  before :each do
    @name = 'test.selah.clockwork.net'
    @bucket = CloudBucket.new(@name)
  end

  it "should create/get a bucket" do
    bucky = CloudBucket.new(@name)
    bucky.should be_instance_of CloudBucket
  end
  
  it "should get a bucket by name" do
    CloudBucket[@name].should be_instance_of CloudBucket
  end
  
  it "should get a list of buckets" do
    CloudBucket.list.should satisfy {|obj| obj.include? @name}
  end
  
  it "should delete a bucket by name" do
    pending("only works sometimes")
    # CloudBucket.delete(@name, true)
    # CloudBucket.list.should_not satisfy {|obj| obj.include? @name}
  end
  
  it "should show the contents of a bucket" do
    @bucket.objects.should be_instance_of Array
  end
  
  it "should add an item to the bucket" do
    @bucket.add __FILE__, 'file'
    @bucket.objects.should satisfy { |obj| obj.include?('file') }
    @bucket << __FILE__
    @bucket.objects.should satisfy { |obj| obj.include? File.basename(__FILE__) }
  end
end
 