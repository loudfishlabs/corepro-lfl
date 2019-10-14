require_relative '../test/core_pro_test_base'
require_relative '../lib/corepro/bank_document'
require_relative '../lib/corepro/models/file_content'

class AfBankDocumentTest < CoreProTestBase
  def test_list
    docs = CorePro::BankDocument.list 'en-US', nil, @@exampleConn, nil
    assert docs.count > 0
    doc = docs[0]
    @@documentId = doc.documentId
    assert_instance_of CorePro::BankDocument, doc
  end

  def test_zzz_download
    doc = CorePro::BankDocument.new
    doc.documentId = @@documentId
    doc.culture = 'en-US'
    file = doc.download(@@exampleConn)
    assert_instance_of CorePro::Models::FileContent, file
  end
end