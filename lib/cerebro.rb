require "cerebro/version"
require 'claide'

module Cerebro
  class << self
    def fork_search
    end
  end

  class CLI
    COMMANDS = %w(search)
    def self.start(argv, options = {})
      argv = CLAide::ARGV.new(argv)
      command = argv.shift_argument
      exit 1 unless Cerebro::CLI::COMMANDS.include?(command)

      if command == "search"
        Cerebro::Commands::Search.run(argv)
      end
    end
  end

  module Commands
    class Search < CLAide::Command
      def initialize(argv)
	@owner = argv.shift_argument
	@repo = argv.shift_argument
	super
      end
      def run
	puts "About to search through forks for #{@owner}/#{@repo}"
      end
    end
  end
end
