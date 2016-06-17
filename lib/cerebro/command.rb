require 'claide'

module Cerebro
  class Command < CLAide::Command
    require 'cerebro/command/search'
    require 'cerebro/command/clean'

    def self.run(argv)
      super(argv)
    end

    def validate!
	    super

      if !Cerebro.storage_directory
        puts <<-HELP
You don't have $HOME set.
Cerebro currently relies on storing cloned fork repos in your home directory.
        HELP
        exit 1
      end
    end
  end
end
