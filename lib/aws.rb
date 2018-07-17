require 'English'

module PaaSCLI::Aws
  def self.ask_for_mfa_from_ykman!(environment)
    ykman_result = `ykman oath code`

    raise "ykman errored: #{ykman_result}" unless $CHILD_STATUS.success?

    mfa = ykman_result
      .lines
      .map(&:chomp)
      .grep(/paas[.]#{environment}/).first
      &.scan(/\d+\z/)&.first

    raise "No mfa found for paas.#{environment}" if mfa.nil? || mfa.empty?

    STDERR.puts "Got mfa #{mfa} for #{environment}"

    mfa
  end

  def self.ask_for_mfa_from_human!(environment)
    STDERR.print "Enter your MFA for #{environment} > "
    STDIN.gets.chomp
  end

  def self.ask_for_mfa!(environment)
    STDERR.puts "Requiring MFA for #{environment}"
    return ask_for_mfa_from_ykman!(environment) unless `which ykman`.empty?
    ask_for_mfa_from_human!(environment)
  end

  def self.account_name(environment)
    "gov-paas-#{environment}"
  end

  def self.credentials_already_exist?(environment)
    creds = `aws-vault list --sessions`
    raise "aws-vault errored: #{creds}" unless $CHILD_STATUS.success?

    !creds.lines.map(&:chomp).grep(/\A#{account_name(environment)}/).empty?
  end

  def self.with_credentials!(environment)
    if credentials_already_exist?(environment)
      creds = `aws-vault exec #{account_name(environment)} -- env`
    else
      mfa = ask_for_mfa!(environment)
      creds = `aws-vault exec #{account_name(environment)}  -m #{mfa} -- env`
    end

    raise "aws-vault errored: #{creds}" unless $CHILD_STATUS.success?

    creds.lines.map(&:chomp).grep(/\AAWS/).map { |l| l.split('=', 2) }.to_h
  end
end
