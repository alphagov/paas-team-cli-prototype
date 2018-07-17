require_relative 'config'

require 'thor'

# not using thor subcommands because it makes the cli slow
class PaaSCLI < Thor

  desc 'bosh', 'bish bash bosh'
  def bosh(*args)
    require_relative 'commands/bosh'
    $0 = 'paas>bosh'
    PaaSCLI::Cmd::Bosh.start args
  end

  desc 'open', 'opens various websites'
  def open(*args)
    require_relative 'commands/open'
    $0 = 'paas>open'
    PaaSCLI::Cmd::Open.start args
  end

end

PaaSCLI.start(ARGV)
