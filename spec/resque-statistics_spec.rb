require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class StatisticJob
  extend Resque::Plugins::Statistics
  @queue = :test

  def self.perform(meta_id, *args)
    MockObject.heavy_lifting( *args )
  end
end

class MockObject
  def self.heavy_lifting(args); end
end


describe Resque::Plugins::Statistics, 'plugin extension' do
  include PerformJob
  
  it 'should play nicly' do
    lambda { Resque::Plugin.lint(Resque::Plugins::Statistics) }.should_not raise_error
  end
  
  it 'should not interfere with the standard job processing' do
    MockObject.should_receive(:heavy_lifting).with("message")
    perform_job(StatisticJob, "message")
  end


  describe Resque::Plugins::Statistics::EnqueuingTime do
    it "should store the enqueueing time" do
      StatisticJob.enqueue :message
      Delorean.time_travel_to "1 hour from now"
      Resque::Job.reserve(:test).perform
      Resque::Plugins::Statistics::EnqueuingTime.average(StatisticJob).should > 60*60
      Resque::Plugins::Statistics::EnqueuingTime.average(StatisticJob).should < 60*60 + 10
      Delorean.back_to_the_present
    end
  end


  describe Resque::Plugins::Statistics::ExecutionTime do
    before(:each) do
      Resque::Plugins::Statistics::ExecutionTime.data_size = 10
    end

    it "should update the execution time whenever executed" do
      Resque::Plugins::Statistics::ExecutionTime.should_receive( :store )
      perform_job( StatisticJob, "message" )
    end
  
    it "should not store more data than configured" do
      12.times do 
        perform_job( StatisticJob, :message )
      end
      Resque::Plugins::Statistics::ExecutionTime.fetch_values(StatisticJob).size.should == Resque::Plugins::Statistics::ExecutionTime.data_size
    end
  
    it "should report the average execution time" do
      10.times do 
        perform_job( StatisticJob, :message )
      end
      Resque::Plugins::Statistics::ExecutionTime.average(StatisticJob).should > 0
      Resque::Plugins::Statistics::ExecutionTime.average(StatisticJob).should < 1
    end
  end


end
