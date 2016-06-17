module Cerebro
  class Searcher
    attr_accessor :forks_dir
    attr_accessor :search_term

    def self.find(forks_dir, search_term)
      new(forks_dir, search_term).matched_forks
    end

    def initialize(forks_dir, search_term)
      @forks_dir = forks_dir
      @search_term = search_term
    end

    def matched_forks
      forks_with_term = []
	    Dir.chdir(@forks_dir) do
        Dir["*"].each do |fork_dir|
          forks_with_term << fork_dir if search_in_fork(fork_dir)
        end
      end
      forks_with_term
    end

    def search_in_fork(fork_dir)
      Dir.chdir(fork_dir) do
        `ag #{@search_term}`
        $?.success?
      end
    end
  end
end
