require "test/unit"
require_relative "../lib/corepro/connection"
require_relative "../lib/corepro/core_pro_api_exception"

class CoreProTestBase < Test::Unit::TestCase

  @config = begin
    if File.exists?('test-config.yml')
      YAML.load(File.open('test-config.yml'))
    else
      raise 'test-config.yml is needed to run the tests'
    end
  rescue ArgumentError => e
    puts "Could not parse YAML: #{e.message}"
  end

  # common properties for tests
  @@timestamp = Time.now.to_s

  @@documentId = nil

  @@exampleConn = CorePro::Connection.new(@config['CoreProApiKey'], @config['CoreProApiSecret'], @config['CoreProDomainName'])

  @@exampleProgramReserveAccountId = nil

  @@exampleCustomerId = nil

  @@exampleAccountId = nil

  @@exampleExternalAccountId = nil

  @@exampleCardId = nil

  @@exampleExternalToInternalTransactionId = nil

  @@exampleExternalToInternalTransactionTag = nil

  @@exampleProgramReserveToInternalTransactionId = nil

  @@exampleVerificationId = nil

  @@exampleChallengeQuestions = nil

  @@exampleProductId = @config['CoreProProductId']
end