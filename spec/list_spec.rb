
require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe Pomo::List do
  before :each do
    @path = File.join(File.dirname(__FILE__), 'pomo_test.dat')
    @list = Pomo::List.new(@path)
    5.times { |i| @list.add Pomo::Task.new("Task #{i}") }
  end

  after :each do
    FileUtils::rm(@path)
  end

  it "stores a path for persistence of data" do
    @list.path.should == @path
  end

  it "can store tasks" do
    @list.tasks.size.should == 5
  end

  it "can persist to disk" do
    @list.save
    File.exist?(@path).should be_true
  end

  it "can load from disk" do
    @list.save
    @list = Pomo::List.new(@path)
    @list.load # not specifically needed, called upon initialization
    @list.tasks.first.should == 'Task 0'
  end

  it "can find all tasks" do
    @list.find('all') do |task, i|
      task.name.should == "Task #{i}"
    end
  end

  it "can find the first task" do
    @list.find('first') do |task, i|
      task.name.should == 'Task 0'
    end
  end

  it "can find the last task" do
    @list.find('last') do |task, i|
      task.name.should == 'Task 4'
    end
  end

  it "can find complete tasks" do
    @list.tasks[2].complete = true
    @list.find('complete') do |task, i|
      task.name.should == 'Task 2'
    end
  end

  it "can find incomplete tasks" do
    @list.tasks[0].complete = true
    @list.find('incomplete') do |task, i|
      task.name.should == "Task #{i+1}"
    end
  end

  it "can find a task by number" do
    @list.find(2) do |task, i|
      task.name.should == 'Task 2'
    end
  end

  it "can find a range of tasks" do
    names = ['Task 3', 'Task 4']
    @list.find('3..4') do |task, i|
      task.name.should == names.shift
    end
  end
end

