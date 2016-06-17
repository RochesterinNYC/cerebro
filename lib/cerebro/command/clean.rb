require 'fileutils'

module Cerebro
  class Command
    class Clean < Command
      self.summary = 'Clean locally stored github repo forks'
      self.description = <<-DESC
	Clean up the repos that you've cloned down via searches
      DESC

      def initialize(argv)
	@clean_specs = argv.arguments
	@repo = argv.shift_argument
	@clean_all = argv.flag?('all')
	super
      end

      def self.options
        [
          ['--all', 'Clean all locally cloned repos used by Cerebro'],
        ].concat(super).reject { |(name, _)| name == '--no-all' }
      end

      def validate!
	super

	if !@clean_all && @clean_specs.length != 1
	  help = <<-HELP
Usage: cerebro clean <repo_name>
	  HELP
	  help! help
	end
      end

      def run
	if @clean_all
	  FileUtils.rm_rf("#{Cerebro.storage_directory}/.")
	  puts "Cleaned up all local clones created by Cerebro"
	else
	  Dir.chdir(Cerebro.storage_directory) do
	    FileUtils.rm_rf("#{@repo}-forks")
	  end
	  puts "Cleaned up all local clones of #{@repo} forks created by Cerebro"
	end
      end
    end
  end
end
