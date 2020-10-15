# frozen_string_literal: true

require 'test_helper'

class ObservationsHelperTest < ActionView::TestCase
  include ObservationsHelper

  setup do
    @observation = observations(:observation)
  end

  test 'format pending observation' do
    assert_equal 'pend.', format_value(@observation)
  end

  test 'format quantitative observation' do
    @observation.value = 10
    assert_equal '10', format_value(@observation)

    @observation.value = 1000
    assert_equal '1,000', format_value(@observation)

    @observation.lab_test = lab_tests(:decimal)
    assert_equal '1,000.0', format_value(@observation)
  end

  test 'format qualitative observation' do
    @observation.update(lab_test: lab_tests(:qualitative),
                        lab_test_value: lab_test_values(:positive))
    assert_equal 'Positive', format_value(@observation)
  end

  test 'format qualitative observation with escaped characters' do
    @observation.update(lab_test: lab_tests(:qualitative),
                        lab_test_value: lab_test_values(:less_than))
    assert_equal '< 10', format_value(@observation)

    @observation.lab_test_value = lab_test_values(:greater_than)
    assert_equal '> 10', format_value(@observation)
  end

  test 'format qualitative observation marked-up with html' do
    @observation.update(lab_test: lab_tests(:qualitative),
                        lab_test_value: lab_test_values(:html))
    assert_equal '<i>E. coli</i>', format_value(@observation)
  end

  test 'format mixed observation' do
    @observation.update(lab_test: lab_tests(:mixed),
                        value: 10,
                        lab_test_value: lab_test_values(:positive))
    assert_equal 'Positive [10]', format_value(@observation)

    @observation.value = 1000
    assert_equal 'Positive [1,000]', format_value(@observation)

    @observation.lab_test_value = lab_test_values(:less_than)
    assert_equal '< 10 [1,000]', format_value(@observation)
  end

  test 'format ratio observation' do
    @observation.update(lab_test: lab_tests(:ratio),
                        value: '1:2')
    assert_equal '1∶2', format_value(@observation)
  end

  test 'format range observation' do
    @observation.update(lab_test: lab_tests(:range),
                        value: '1-2')
    assert_equal '1–2', format_value(@observation)
  end

  test 'format fraction observation' do
    @observation.update(lab_test: lab_tests(:fraction),
                        value: '1/2')
    assert_equal '1 ∕ 2', format_value(@observation)
  end

  test 'format text observation' do
    @observation.update(lab_test: lab_tests(:text),
                        value: 'This is the observation')
    assert_equal 'This is the observation', format_value(@observation)
  end

  test 'qualitative-only observations should not have units' do
    @observation.update(lab_test: lab_tests(:mixed),
                        value: nil,
                        lab_test_value: lab_test_values(:positive))
    assert_nil format_units(@observation)
  end

  test 'numerical-qualitative observations should have units' do
    @observation.update(lab_test: lab_tests(:mixed),
                        value: nil,
                        lab_test_value: lab_test_values(:less_than))
    assert_equal 'Units', format_units(@observation)
  end

  test 'quantitative observations should have units' do
    @observation.update(lab_test: lab_tests(:mixed),
                        value: 10,
                        lab_test_value: lab_test_values(:positive))
    assert_equal 'Units', format_units(@observation)
  end

  test 'reference range table contains less than symbol' do
    observation_ranges = [[nil, nil, nil, '<', '10']]
    assert_equal '<table><tbody><tr><td class="range_0"></td><td class="range_1"></td><td class="range_2"></td><td class="range_3">&lt;</td><td class="range_4">10</td></tr></tbody></table>',
                 ranges_table(observation_ranges)
  end

  test 'reference range table contains greater than symbol' do
    observation_ranges = [[nil, nil, nil, '≥', '10']]
    assert_equal '<table><tbody><tr><td class="range_0"></td><td class="range_1"></td><td class="range_2"></td><td class="range_3">≥</td><td class="range_4">10</td></tr></tbody></table>',
                 ranges_table(observation_ranges)
  end

  test "reference range table contains gender info if patient's gender is unknown" do
    observation_ranges = [['M: ', nil, '0', '–', '10'],
                          ['F: ', nil, '100', '–', '200']]
    assert_equal '<table><tbody><tr><td class="range_0">M: </td><td class="range_1"></td><td class="range_2">0</td><td class="range_3">–</td><td class="range_4">10</td></tr><tr><td class="range_0">F: </td><td class="range_1"></td><td class="range_2">100</td><td class="range_3">–</td><td class="range_4">200</td></tr></tbody></table>',
                 ranges_table(observation_ranges)
  end
end
