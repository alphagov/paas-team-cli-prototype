require 'thor'

module PaaSCLI::Cmd
  class Bosh < Thor
    desc 'cli $environment $deployment',
         'opens a bosh cli in $environment $deployment | paas bosh dev farms'
    def cli(env, deployment)
      STDERR.puts '🔀   using make to open a bosh cli'
      pid = spawn(
        {
          'DEPLOY_ENV' => deployment
        },
        "set -ue; cd #{BOOTSTRAP_PATH}; make #{env} bosh-cli",
        in: STDIN,
        out: STDOUT,
        err: STDERR,
      )
      Process.wait pid
    end
  end
end
