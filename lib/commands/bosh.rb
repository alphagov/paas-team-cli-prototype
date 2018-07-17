require 'thor'

module PaaSCLI::Cmd
  class Bosh < Thor
    desc 'cli $environment $deployment',
         'opens a bosh cli in $environment $deployment | paas bosh dev farms'
    def cli(environment, deployment)
      STDERR.puts '🔀   using make to open a bosh cli'

      env_vars = {}
        .merge(PaaSCLI::Environment.with_environment(environment))
        .merge(PaaSCLI::Environment.with_deployment(environment, deployment))
        .merge(PaaSCLI::Aws.with_credentials!(environment))

      pid = spawn(
        env_vars,
        "set -ue; cd #{BOOTSTRAP_PATH}; make bosh-cli",
        in: STDIN,
        out: STDOUT,
        err: STDERR,
      )
      Process.wait pid
    end
  end
end
