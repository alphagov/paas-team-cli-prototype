require 'thor'

DOCS_URL   = 'https://docs.cloud.service.gov.uk/#gov-uk-platform-as-a-service'
MANUAL_URL = 'https://team-manual.cloud.service.gov.uk/#paas-team-manual'
STATUS_URL = 'https://status.cloud.service.gov.uk/'

module PaaSCLI::Cmd
  class Open < Thor
    desc 'docs', 'opens the public docs'
    def docs
      spawn("open #{DOCS_URL}")
      STDERR.puts '✅  opened public docs'
    end

    desc 'manual', 'opens the team manual'
    def manual
      spawn("open #{MANUAL_URL}")
      STDERR.puts '✅  opened the team manual'
    end

    desc 'status', 'opens the status page'
    def status
      spawn("open #{STATUS_URL}")
      STDERR.puts '✅  opened the status page'
    end

    desc 'concourse $environment $deployment',
         'opens concourse for $environment $deployment | paas open concourse dev towers'
    def concourse(environment, deployment)
      spawn(
        "open https://deployer.#{deployment}.#{environment}.cloudpipeline.digital/"
      )
      STDERR.puts '✅  opened concourse'
    end
  end
end
