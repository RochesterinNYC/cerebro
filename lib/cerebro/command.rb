require 'claide'

module Cerebro
  class Command < CLAide::Command
    require 'cerebro/command/search'

    def self.run(argv)
      super(argv)
    end
  end
end
