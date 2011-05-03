
require File.dirname(__FILE__) + '/spec_helper'

describe Pomo::Task do
  before :each do
    @task = Pomo::Task.new('test task')
  end

  it "has a name" do
    @task.name.should == 'test task'
  end

  it "has a default length" do
    @task.length.should == 25
  end

  it "is not complete by default" do
    @task.should_not be_complete
  end

  it "can change its name" do
    @task.name = 'another task'
    @task.name.should == 'another task'
  end

  it "can change its length" do
    @task.length = 30
    @task.length.should == 30
  end

  it "can be completed" do
    @task.complete = true
    @task.should be_complete
  end

  it "can be started" do
    pending 'not sure how to spec the progress bar'
  end
end

