require 'spec_helper'

describe Pomo::TimeEntry do

  let(:config) do
    {
      domain: 'foo',
      username: 'bar',
      password: 'baz'
    }
  end

  describe '#test_config' do

    let(:entry) do
      described_class.new.tap do |entry|
        entry.stub(project: double, task: double)
      end
    end

    it "raises an error if project can't be found" do
      entry.stub(project: nil)
      expect{ entry.test_config(config) }.to raise_error("Couldn't find project")
    end

    it "raises an error if task can't be found" do
      entry.stub(task: nil)
      expect{ entry.test_config(config) }.to raise_error("Couldn't find task type")
    end

  end

  describe '#notes' do

    it 'concats name and description' do
      entry = described_class.new(name: "Name", description: "Description")
      expect(entry.notes).to eql("Name - Description")
    end

  end

  describe '#date' do

    it 'formats the date d/m/y' do
      Date.stub(today: Date.new(2001,1,1))
      expect(described_class.new.date).to eql("01/01/2001")
    end

  end

  describe '#hours' do

    it 'converts minutes to hours' do
      expect(described_class.new(minutes: 60).hours).to be(1.00)
    end

    it 'round to hundreths' do
      expect(described_class.new(minutes: 61).hours).to be(1.02)
    end

  end
end
