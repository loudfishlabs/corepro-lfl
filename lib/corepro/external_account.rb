require_relative 'models/model_base'
require_relative 'utils/requestor'
require_relative 'models/external_account_id_only'
require_relative 'models/external_account_verify'

module CorePro
  class ExternalAccount < Models::ModelBase

    attr_accessor :customerId
    attr_accessor :externalAccountId
    attr_accessor :name
    attr_accessor :tag
    attr_accessor :nickName
    attr_accessor :firstName
    attr_accessor :lastName
    attr_accessor :type
    attr_accessor :status
    attr_accessor :statusDate
    attr_accessor :routingNumber
    attr_accessor :routingNumberMasked
    attr_accessor :accountNumber
    attr_accessor :accountNumberMasked
    attr_accessor :nocCode
    attr_accessor :isActive
    attr_accessor :isLocked
    attr_accessor :lockedDate
    attr_accessor :lockedReason
    attr_accessor :customField1
    attr_accessor :customField2
    attr_accessor :customField3
    attr_accessor :customField4
    attr_accessor :customField5
    attr_accessor :lastModifiedDate

    def self.list(customerId, connection = nil, loggingObject = nil)
      CorePro::Utils::Requestor.get("/externalaccount/list/#{customerId}", ExternalAccount, connection, loggingObject)
    end

    def self.get(customerId, externalAccountId, connection = nil, loggingObject = nil)
      CorePro::Utils::Requestor.get("/externalaccount/get/#{customerId}/#{externalAccountId}", ExternalAccount, connection, loggingObject)
    end

    def self.getByTag(customerId, tag, connection = nil, loggingObject = nil)
      CorePro::Utils::Requestor.get("/externalaccount/getByTag/#{customerId}/#{escape(tag)}", ExternalAccount, connection, loggingObject)
    end

    def create(connection = nil, loggingObject = nil)
      eaid = CorePro::Utils::Requestor.post('/externalaccount/create', CorePro::Models::ExternalAccountIdOnly, self, connection, loggingObject)
      eaid.externalAccountId
    end

    def initiate(connection = nil, loggingObject = nil)
      CorePro::Utils::Requestor.post('/externalaccount/initiate', CorePro::Models::ExternalAccountIdOnly, self, connection, loggingObject)
    end

    def self.verify(customerId, externalAccountId, amount1, amount2, connection = nil, loggingObject = nil)
      ea = ExternalAccount.new
      ea.customerId = customerId
      ea.externalAccountId = externalAccountId
      ea.verify(amount1, amount2, connection, loggingObject)
    end

    def verify(amount1, amount2, connection = nil, loggingObject = nil)
      eav = CorePro::Models::ExternalAccountVerify.new
      eav.customerId = @customerId
      eav.externalAccountId = @externalAccountId
      eav.amount1 = @amount1
      eav.amount2 = @amount2
      CorePro::Utils::Requestor.post('/externalaccount/verify', eav, self, connection, loggingObject)
      true
    end

    def update(connection = nil, loggingObject = nil)
      eaid = CorePro::Utils::Requestor.post('/externalaccount/update', CorePro::Models::ExternalAccountIdOnly, self, connection, loggingObject)
      eaid.externalAccountId
    end

    def archive(connection = nil, loggingObject = nil)
      eaid = CorePro::Utils::Requestor.post('/externalaccount/deactivate', CorePro::Models::ExternalAccountIdOnly, self, connection, loggingObject)
      eaid.externalAccountId
    end

  end
end
