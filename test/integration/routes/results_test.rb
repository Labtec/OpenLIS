# frozen_string_literal: true

require 'test_helper'

class ResultsRoutesTest < ActionDispatch::IntegrationTest
  test 'routes results' do
    assert_routing '/accessions/1/results',
                   controller: 'results', action: 'index', accession_id: '1'
  end
end
