require 'spec_helper'

describe Pomo::Task do

  describe '#start' do

    context 'when project and type are passed in' do

      let(:task) do
        Pomo::Task.new 'foo', project: 'Project', type: 'Type'
      end

      let(:config) do
        tracker_config = { domain: 'domain', username: 'user', password: 'pass' }
        options = Pomo::Configuration.default_options.merge(tracker: tracker_config)
        Pomo::Configuration.new(options)
      end

      # Stub out the TimeEntry object
      let(:time_entry) do
        Pomo::TimeEntry.new.tap do |entry|
          entry.stub(test_config: true, log: true)
          task.stub(time_entry: entry)
        end
      end

      it 'tests the tracker config' do
        expect(time_entry).to receive(:test_config).with(config.tracker)
        task.start(config)
      end

    end

  end

  describe '#stop' do
    it 'does nada'
  end

end
