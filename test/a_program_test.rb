require_relative 'core_pro_test_base'
require_relative '../lib/corepro/program'

class AProgramTest < CoreProTestBase
  def test_get
    p = CorePro::Program.get @@exampleConn, nil
    pa = p.accounts.select {|e| e.type == 'ProgramReserve'}
    @@exampleProgramReserveAccountId = pa[0].programAccountId
    assert_not_nil(@@exampleProgramReserveAccountId)
    puts "Program Reserve AccountId=#{@@exampleProgramReserveAccountId}"
  end
end