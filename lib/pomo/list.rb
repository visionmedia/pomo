
module Pomo
  class List
    
    ##
    # List path.
    
    attr_reader :path
    
    ##
    # Task array.
    
    attr_accessor :tasks
    
    ##
    # Initialize with _path_.
    
    def initialize path
      @path = File.expand_path path
      @tasks = []
      load rescue save
    end
    
    ##
    # Find tasks by _args_, iterating with _block_.
    #
    # Supports the following:
    #
    #  * n
    #  * n n n
    #  * n..n
    #  * n..-n
    #  * first
    #  * last
    #  * incomplete
    #  * complete[d]
    #  * all
    #
    
    def find *args, &block
      found = []
      found << tasks.first if args.empty?
      if args.include? 'all'
        found = tasks
      elsif args.include? 'first'
        found << tasks.first
      elsif args.include? 'last'
        found << tasks.last
      elsif args.include?('complete') || args.include?('completed')
        found = tasks.select { |task| task.complete? }
      elsif args.include? 'incomplete'
        found = tasks.select { |task| not task.complete? }
      elsif args.any? { |arg| arg =~ /(\d+)\.\.(-?\d+)/ }
        found = tasks[$1.to_i..$2.to_i]
      else
        tasks.each_with_index do |task, i|
          found << task if args.any? { |a| a.to_i == i } 
        end
      end
      found.each_with_index do |task, i|
        yield task, i
      end
    end
    
    ##
    # Add _task_ to the list in memory (requires saving).
    
    def add task
      @tasks << task
    end
    alias :<< :add

    ##
    ## Move task at _from_ position to new _to_ position (requres saving).

    def move from, to
      list = Array.new(@tasks.size)
      list[position(to)] = @tasks[position(from)]
      @tasks.each_with_index do |task, index|
        next if index == position(from)
        list[list.find_index(nil)] = task
      end
      @tasks = list
    end
    
    ##
    # Save the list.
    
    def save
      File.open(path, 'w') do |file|
        file.write YAML.dump(tasks)
      end
      self
    end
    
    ##
    # Load the list.
    
    def load
      @tasks = YAML.load_file path
      self
    end

    ## 
    # Determine position from argument.

    def position arg
      return case arg.downcase
        when 'first' then 0
        when 'last' then @tasks.size-1
        else arg.to_i > @tasks.size-1 ? @tasks.size-1 : arg.to_i
        end
    end
    private :position
  end
end
