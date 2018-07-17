module PaaSCLI::Environment
  def self.overrides(env_var_names)
    overriden_vars = env_var_names & ENV.keys
    ENV.select { |k, _| overriden_vars.include? k }
  end

  def self.with_environment(environment)
    all_env_vars = {
      'dev' => Hash[
        'ALERT_EMAIL_ADDRESS',       'govpaas-alerting-dev@digital.cabinet-office.gov.uk',
        'AWS_ACCOUNT',               'dev',
        'AWS_DEFAULT_REGION',        'eu-west-1',
        'CONCOURSE_AUTH_DURATION',   '48h',
        'DISABLE_HEALTHCHECK_DB',    'true',
        'DISABLE_PIPELINE_LOCKING',  'true',
        'ENABLE_AUTODELETE',         'true',
        'ENABLE_DATADOG',            'false',
        'ENABLE_DESTROY',            'true',
        'ENABLE_MORNING_DEPLOYMENT', 'true',
        'ENV_SPECIFIC_CF_MANIFEST',  'cf-default.yml',
        'MAKEFILE_ENV_TARGET',       'dev',
        'PERSISTENT_ENVIRONMENT',    'false',
        'SKIP_COMMIT_VERIFICATION',  'true',
        'TEST_HEAVY_LOAD',           'true',
      ]
    }

    raise "Env '#{environment}' not found" unless all_env_vars.key? environment
    all_env_vars[environment].merge overrides(all_env_vars[environment].keys)
  end

  def self.with_deployment(environment, deployment)
    all_env_vars = {
      'dev' => Hash[
        'APPS_DNS_ZONE_NAME',   "#{deployment}.dev.cloudpipelineapps.digital",
        'DEPLOY_ENV',           deployment,
        'SYSTEM_DNS_ZONE_NAME', "#{deployment}.dev.cloudpipeline.digital",
      ]
    }

    raise "Env '#{environment}' not found" unless all_env_vars.key? environment
    all_env_vars[environment].merge overrides(all_env_vars[environment].keys)
  end
end
