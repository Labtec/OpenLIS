require 'test_helper'

class AccessionTest < ActiveSupport::TestCase

  test 'insured patient order' do
    patient = patients(:insured)
    lab_test = LabTest.last
    doctor = doctors(:doctor)
    user = users(:user)
    accession = patient.accessions.build(
      drawn_at: Time.current,
      drawer: user,
      received_at: Time.current,
      receiver_id: user,
      lab_test_ids: [lab_test.id]
    )

    assert accession.valid?, 'Insured patient order is not valid'

    accession.doctor = doctor
    assert accession.invalid?, 'An order from a physician without ICD9'

    accession.icd9 = 'V70.0'
    assert accession.valid?, 'Insured patient order should be valid'
  end
end
