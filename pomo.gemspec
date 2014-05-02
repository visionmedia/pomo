# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pomo/os'
require 'pomo/version'

Gem::Specification.new do |spec|
  spec.name              = 'pomo'
  spec.version           = Pomo::VERSION
  spec.authors           = ['TJ Holowaychuk', 'Steve McKinney']
  spec.email             = ['tj@vision-media.ca', 'stevemckinney@gmail.com']
  spec.summary           = "pomo-#{Pomo::VERSION}"
  spec.description       = 'Pomodoro time management for the command-line'
  spec.homepage          = 'https://github.com/visionmedia/pomo'

  spec.rubyforge_project = 'pomo'

  spec.files             = `git ls-files`.split($/)
  spec.executables       = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files        = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths     = ['lib']
  spec.rdoc_options      = ['--line-numbers', '--inline-source', '--title', 'Pomo', '--main', 'README.md']

  spec.add_dependency('commander', '~> 4.1')
  spec.add_dependency('octokit', '~> 3.1')
  spec.add_dependency('harvested', '~> 2.0.0')
  spec.add_dependency('terminal-notifier', '~> 1.4') if Pomo::OS.mac?
  spec.add_dependency('growl', '~> 1.0')             if Pomo::OS.mac? || Pomo::OS.windows?
  spec.add_dependency('libnotify', '~> 0.8')         if Pomo::OS.linux?
end
