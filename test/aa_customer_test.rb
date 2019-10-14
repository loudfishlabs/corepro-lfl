require_relative 'core_pro_test_base'
require_relative '../lib/corepro/customer'
require_relative '../lib/corepro/models/customer_address'
require_relative '../lib/corepro/models/customer_response'

class AaCustomerTest < CoreProTestBase

  # def test_aaa_create
  #   c = CorePro::Customer.new
  #   c.birthDate = '01/01/1985'
  #   c.culture = 'en-US'
  #   c.firstName = 'Joey'
  #   c.middleName = 'Flanagan'
  #   c.lastName = "McTester#{@@timestamp}"
  #   c.gender = 'M'
  #   c.isDocumentsAccepted = true
  #   c.isSubjectToBackupWithholding = false
  #   c.isOptedInToBankCommunication = false
  #   c.tag = "jfm#{@@timestamp}"
  #   c.taxId = '012341234'
  #   p = CorePro::Models::CustomerPhone.new
  #   p.phoneType = 'mobile'
  #   p.number = '515-555-1234'
  #   c.phones.push(p)
  #
  #   ra = CorePro::Models::CustomerAddress.new
  #   ra.addressLine1 = '123 Main Street'
  #   ra.city = 'Anytown'
  #   ra.state = 'IA'
  #   ra.postalCode = '55555'
  #   ra.addressType = 'residence'
  #   ra.country = 'US'
  #   ra.isActive = 1
  #   c.addresses.push(ra)
  #
  #   #@@exampleCustomerInitiateResponse = c.initiate(@@exampleConn, nil)
  #   @@exampleCustomerId = c.create(@@exampleConn, nil)
  #   puts "customerId=#{@@exampleCustomerId}"
  #   assert @@exampleCustomerId > 0
  # end

  def test_aaa_initiate
    c = CorePro::Customer.new
    c.birthDate = '1975-02-28'
    c.culture = 'en-US'
    c.firstName = 'John'
    c.lastName = "Smith"
    c.gender = 'M'
    c.isDocumentsAccepted = true
    c.isSubjectToBackupWithholding = false
    c.isOptedInToBankCommunication = true
    c.tag = "js#{@@timestamp}"
    c.taxId = '112223333'
    p = CorePro::Models::CustomerPhone.new
    p.phoneType = 'Mobile'
    p.number = '515-555-1234'
    c.phones.push(p)

    ra = CorePro::Models::CustomerAddress.new
    ra.addressLine1 = '222333 Peachtree Place'
    ra.city = 'Atlanta'
    ra.state = 'GA'
    ra.postalCode = '30318'
    ra.addressType = 'Residence'
    ra.country = 'US'
    ra.isActive = 1
    c.addresses.push(ra)

    response = c.initiate(@@exampleConn, nil)
    @@exampleCustomerId = response.customerId
    @@exampleVerificationId = response.verificationId
    @@exampleChallengeQuestions = response.questions
    puts "customerId=#{@@exampleCustomerId}"
    assert_not_nil(@@exampleCustomerId)
    assert_not_nil(@@exampleVerificationId)
    assert @@exampleChallengeQuestions.count > 0
    assert_equal(response.verificationStatus.downcase, "success")
  end

 def test_aaa_verify
   c = CorePro::Customer.new
   c.customerId = @@exampleCustomerId
   answers = []
   @@exampleChallengeQuestions.each do |q|
     answer = CorePro::Models::CustomerAnswer.new
     answer.questionType = q.type
     answer.questionAnswer = get_correct_answer(q.prompt, q.answers)
     answers << answer
   end
   response = c.verify(@@exampleVerificationId, @@exampleCustomerId, answers, @@exampleConn)
   assert_equal(response.verificationStatus.downcase, 'success')
 end

  def test_get
    puts "getting #{@@exampleCustomerId}..."
    c = CorePro::Customer.get @@exampleCustomerId, @@exampleConn, nil
    assert c != nil, "Could not 'get' customerId #{@@exampleCustomerId}"
  end

  def test_getByTag
    c = CorePro::Customer.getByTag "js#{@@timestamp}", @@exampleConn, nil
    assert c != nil, "Could not 'getByTag' tag 'js#{@@timestamp}'"
  end

  def test_list
    cs = CorePro::Customer.list 0, 15, @@exampleConn, nil
    assert cs != nil && cs.length > 0, "Could not list customers"
  end

  def test_search
    c = CorePro::Customer.new
    c.lastName = "Smith"
    cs = c.search nil, nil, @@exampleConn, nil
    assert cs != nil && cs.length > 0, "Could not search 'Smith'"
  end

  def test_update
    c = CorePro::Customer.new
    c.customerId = @@exampleCustomerId
    c.gender = "U"
    customerId = c.update @@exampleConn, nil
    assert customerId > 0
  end

  private
  # Gets the correct answer for a given question in Q2's Sandbox Environment
  # @see Test IDology Credentials.pdf
  #
  # @param [String] question_prompt
  # @param [Array<String>] answers - array with all possible answers to the question
  #
  # @return [String] the correct answer for the given question
  def get_correct_answer(question_prompt, answers)
    question_prompt = question_prompt.downcase
    answer = nil
    case question_prompt
    when /which number goes with your street on/
      answer = answers[answers.index('3612') || answers.index('5555') || answers.index('None of the above')]
    when /which street have you lived on/
      answer = answers[answers.index('BEACH') || answers.index('None of the above') || 0]
    when /in which city is/
      answer = answers[answers.index('ATLANTA') || answers.index('None of the above')]
    when /in which county was your/
      answer = answers[answers.index('FULTON') || answers.index('None of the above')]
    when /what year is your/
      answer = answers[answers.index('2005')]
    when /which of the following people do you know/
      answer = answers[answers.index('ANTHONY BROWN') || answers.index('None of the above')]
    when /in wich year were you born/
      answer = answers[answers.index('1975')]
    when /what type of residence is/
      answer = answers[answers.index('Single Family Residence')]
    when /in which month month were you born/
      answer = answers[answers.index('FEBRUARY')]
    when /in which county have you lived/
      answer = answers[answers.index('FULTON') || answers.index('None of the above')]
    when /what are the last two digits of your social security number/
      answer = answers[answers.index('33')]
    when /at which of the following addresses have you lived/
      answer = answers[answers.index('None of the above')]
    when /which person is not a relative or someone that you know/
      answer = answers.grep(/SMITH/).first
    when /with which name are you associated/
      answer = answers[answers.index('None of the above')]
    when /what are the first two digits of your social security number/
      answer = answers[answers.index('11') || answers.index('None of the above')]
    when /which of the following phone numbers is related to you/
      answer = answers[answers.index('None of the above')]
    when /from whom did you purchase the property at/
      answer = answers[answers.index('JOE ANDERSON') || answers.index('None of the above')]
    when /how long have you been associated with the property at/
      answer = answers[answers.index('Over 5 years')]
    when /what is the approximate square footage of the property at/
      answer = answers[answers.index('Over 2,500')]
    when /when did you purchase the property at/
      answer = answers[answers.index('August 1999') || answers.index('None of the above')]
    when /between/ && /in which state did you live/
      answer = answers[answers.index('NEW YORK')]
    when /when did you purchase or lease your/
      answer = answers[answers.index('December 2006')]
    when /with which name are you associated/
      answer = answers[answers.index('None of the above')]
    end
    answer
  end
end