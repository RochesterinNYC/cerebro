require 'octokit'
require 'fileutils'

module Cerebro
  class Command
    class Search < Command
      self.summary = 'Search through github repo forks'
      self.description = <<-DESC
	Search through forks of the specified repo for a search term
      DESC

      def initialize(argv)
	@search_specs = argv.arguments
	@owner = argv.shift_argument
	@repo = argv.shift_argument
	@search_term = argv.shift_argument
	@deep_clone = argv.flag?('deep')
	@github_token = ENV.fetch('GITHUB_TOKEN', nil)
	@home_dir = ENV.fetch('HOME', nil)
	super
      end

      def self.options
        [
          ['--deep', 'Use full git cloning instead of shallow clones'],
        ].concat(super).reject { |(name, _)| name == '--no-deep' }
      end

      def validate!
	super

	if @search_specs.length != 3
	  help = <<-HELP
  Usage: GITHUB_TOKEN=<github_token> cerebro search <repo_owner> <repo_name> <search_term>
	  HELP
	  help! help
	end
	if !@github_token
	  puts <<-HELP
  Please specify or pass in GITHUB_TOKEN as an environment variable.
  Usage: GITHUB_TOKEN=<github_token> cerebro search <repo_owner> <repo_name> <search_term>
	  HELP
	  exit 1
	end
	if !@home_dir
	  puts <<-HELP
  You don't have $HOME set.
  Cerebro currently relies on storing cloned fork repos in your home directory.
	  HELP
	  exit 1
	end
      end

      def run
	# Setup Github API
	Octokit.auto_paginate = true
	Octokit.configure do |c|
	  c.access_token = @github_token
	end

	full_repo_name = "#{@owner}/#{@repo}"
	forks_with_term = []

	# Get all forks
	forks = Octokit.forks(full_repo_name)
	forks_directory = File.join(@home_dir, ".cerebro", "#{@repo}-forks")
	FileUtils.mkdir_p forks_directory

	Dir.chdir(forks_directory) do
	  puts "Found #{forks.count} forks of #{full_repo_name}"
	  puts "All forks will be stored in #{forks_directory}"
	  puts "Searching through these forks now..."
	  forks.each do |git_fork|
	    forked_dir = File.join(forks_directory, "#{git_fork.owner.login}-#{git_fork.name}")
	    if Dir.exists?(forked_dir)
	      Dir.chdir(forked_dir) do
		`git pull -r`
	      end
	    else
	      shallow = @deep_clone ? "" : "--depth 1"
	      `git clone #{shallow} #{git_fork.ssh_url} #{forked_dir}`
	    end
	    Dir.chdir(forked_dir) do
	      `ag #{@search_term}`
	      if $?.success?
		forks_with_term << git_fork.full_name
	      end
	    end
	  end
	end
	puts <<-RESULTS

  ----------------Search Results---------------------
	RESULTS
	forks_with_term.each do |repo_identifier|
	  puts "Found #{@search_term} in #{repo_identifier}"
	end
	puts
	puts "Found \"#{@search_term}\" in #{forks_with_term.count} forks out of total #{forks.count} forks of #{full_repo_name}"
	puts
	puts "Clones of forked repos are located in #{Dir.pwd}/#{forks_directory}"
      end
    end
  end
end
