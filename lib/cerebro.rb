require "cerebro/version"

module Cerebro
  autoload :Command,  'cerebro/command'
  autoload :Searcher, 'cerebro/searcher'

  def self.storage_directory
    home_dir = ENV.fetch('HOME', nil)
    home_dir.empty? ? nil : File.join(home_dir, ".cerebro")
  end
end
