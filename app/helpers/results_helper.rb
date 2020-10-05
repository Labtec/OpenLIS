# frozen_string_literal: true

module ResultsHelper
  def doctor_name(doctor)
    if doctor
      t('.doctor')
      tag.strong(doctor.name)
    else
      tag.strong(t('.outpatient'))
    end
  end

  def format_value(result)
    if result.lab_test.derivation?
      number_with_precision(result.derived_value, precision: result.lab_test_decimals, delimiter: ',') || 'calc.'
    elsif result.lab_test_value && result.value.present?
      [result.lab_test_value.value,
       ' [',
       number_with_precision(result.value, precision: result.lab_test_decimals, delimiter: ','),
       ']'].join
    elsif result.lab_test_value
      result.lab_test_value.value
    elsif result.value.blank?
      'pend.'
    elsif result.lab_test.ratio?
      result.value.tr(':', '∶')
    elsif result.lab_test.range?
      result.value.tr('-', '–')
    elsif result.lab_test.fraction?
      result.value.gsub(%r{/}, ' ∕ ')
    elsif result.lab_test.text_length?
      result.value
    else
      number_with_precision(result.value, precision: result.lab_test_decimals, delimiter: ',')
    end
  end

  def format_units(result)
    result.unit_name unless result.lab_test_value &&
                            !result.lab_test_value.numeric? &&
                            result.value.blank?
  end

  def flag_name(result)
    case result.flag
    when '<'
      t('results.off_scale_low')
    when '>'
      t('results.off_scale_high')
    when 'A'
      t('results.abnormal')
    when 'AA'
      t('results.abnormal') * 2
    when 'DET'
      t('results.detected')
    when 'E'
      t('results.equivocal')
    when 'H'
      t('results.high')
    when 'HH'
      t('results.high') * 2
    when 'I'
      t('results.intermediate')
    when 'IND'
      t('results.indeterminate')
    when 'L'
      t('results.low')
    when 'LL'
      t('results.low') * 2
    when 'N'
      t('results.normal')
    when 'ND'
      t('results.not_detected')
    when 'NEG'
      t('results.negative')
    when 'NR'
      t('results.non_reactive')
    when 'NS'
      t('results.non_susceptible')
    when 'POS'
      t('results.positive')
    when 'R'
      t('results.resistant')
    when 'RR'
      t('results.reactive')
    when 'S'
      t('results.susceptible')
    when 'WR'
      t('results.weakly_reactive')
    end
  end

  def flag_color(result)
    case result.flag
    when *LabTestValue::ABNORMAL_FLAGS
      'abnormal_value'
    when *LabTestValue::HIGH_FLAGS
      'high_value'
    when *LabTestValue::LOW_FLAGS
      'low_value'
    else
      'normal_value'
    end
  end

  def ranges_table(ranges)
    tag.table do
      tag.tbody do
        safe_join(ranges.collect do |range|
          tag.tr do
            range.each_with_index do |column, index|
              concat tag.td(column, class: "range_#{index}")
            end
          end
        end)
      end
    end
  end

  def registration_number(inline = false)
    if current_user.register.present?
      if inline
        " / #{t('results.index.register')} #{current_user.register}"
      else
        "#{t('results.index.register')} #{current_user.register}"
      end
    else
      ''
    end
  end

  def result_input(builder, result)
    if result.lab_test.derivation?
      text_field_tag :value, format_value(result), disabled: true
    elsif result.lab_test_values?
      builder.text_field :value
    else
      builder.collection_select(:lab_test_value_id,
                                LabTest.find(result.lab_test_id).lab_test_values,
                                :id, :stripped_value,
                                include_blank: true) +
        (builder.text_field(:value) if result.result_types?)
    end
  end
end
