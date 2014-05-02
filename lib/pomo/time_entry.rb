require 'harvested'

module Pomo
  class TimeEntry

    attr_accessor :options, :config

    def initialize(options = {})
      self.options = options
    end

    ##
    # Check that the project and task were found on Harvest

    def test_config(config)
      self.config = config

      raise "Couldn't find project"   unless project
      raise "Couldn't find task type" unless task
    end

    ##
    # Persist time entry to Harvest tracker

    def log(config)
      self.config = config

      options = {
        notes: notes,
        hours: hours,
        spent_at: date,
        project_id: project.id,
        task_id: task.id
      }
      entry = Harvest::TimeEntry.new(options)
      harvest.time.create(entry)
    end

    ##
    # Notes to send to tracker

    def notes
      "#{options[:name]} - #{options[:description]}"
    end

    ##
    # Date for task (today), formatted properly for tracker

    def date
      Date.today.strftime("%d/%m/%Y")
    end

    ##
    # Duration of task in hours

    def hours
      unrounded = (options[:minutes] / 60.0)
      (unrounded * 100).ceil / 100.0
    end

    ##
    # Harvest project with name matching options[:project]

    def project
      time_api = Harvest::API::Time.new(harvest.credentials)
      time_api.trackable_projects.find do |project|
        project.name == options[:project]
      end
    end

    ##
    # Harvest task with name matching options[:task]

    def task
      project.tasks.find do |task|
        task.name == options[:task]
      end
    end

    private

    def harvest
      @harvest ||= Harvest.client(config[:domain], config[:username], config[:password])
    end

  end
end
