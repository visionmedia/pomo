
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
    @list.tasks.first.name.should == 'Task 0'
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

  it "can move a task's position from first to last" do
    @list.move('first', 'last')
    @list.tasks.first.name.should == 'Task 1'
    @list.tasks.last.name.should == 'Task 0'
  end

  it "can move a task's position from last to first" do
    @list.move('last', 'first')
    @list.tasks.first.name.should == 'Task 4'
    @list.tasks.last.name.should == 'Task 3'
  end

  it "can move a task's position with numbers forwards" do
    @list.move('1', '3')
    @list.tasks[0].name.should == 'Task 0'
    @list.tasks[1].name.should == 'Task 2'
    @list.tasks[2].name.should == 'Task 3'
    @list.tasks[3].name.should == 'Task 1'
    @list.tasks[4].name.should == 'Task 4'
  end

  it "can move a task's position with numbers backwards" do
    @list.move('3', '1')
    @list.tasks[0].name.should == 'Task 0'
    @list.tasks[1].name.should == 'Task 3'
    @list.tasks[2].name.should == 'Task 1'
    @list.tasks[3].name.should == 'Task 2'
    @list.tasks[4].name.should == 'Task 4'
  end

  it "uses equivalent of 'last' for all arguments larger than size of task list" do
    @list.move('first', '100')
    @list.tasks.first.name.should == 'Task 1'
    @list.tasks[4].name.should == 'Task 0'
    @list.tasks.size.should == 5
  end
end

