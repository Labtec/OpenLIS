# frozen_string_literal: true

module ResultsHelper
  def doctor_name(doctor)
    if doctor
      t('.doctor')
      content_tag :strong, doctor.name
    else
      content_tag :strong, t('.walk_in')
    end
  end

  def format_value(result)
    if result.lab_test.derivation?
      number_with_precision(result.derived_value, precision: result.lab_test_decimals, delimiter: ',')
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
      result.value.gsub(/[:]/, '∶')
    elsif result.lab_test.range?
      result.value.gsub(/[-]/, '–')
    elsif result.lab_test.fraction?
      result.value.gsub(%r{[/]}, ' ∕ ')
    elsif result.lab_test.text_length?
      result.value
    else
      number_with_precision(result.value, precision: result.lab_test_decimals, delimiter: ',')
    end
  end

  def flag_name(result)
    case result.flag
    when 'A'
      t('results.abnormal')
    when 'H'
      t('results.high')
    when 'L'
      t('results.low')
    end
  end

  def flag_color(result)
    case result.flag
    when 'A'
      'abnormal_value'
    when 'H'
      'high_value'
    when 'L'
      'low_value'
    else
      'normal_value'
    end
  end

  def ranges_table(ranges)
    content_tag :table do
      content_tag :tbody do
        safe_join(ranges.collect do |range|
          content_tag :tr do
            range.each_with_index do |column, index|
              concat content_tag :td, column, class: "range_#{index}"
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

  def result_input(r, result)
    if result.lab_test.derivation?
      text_field_tag :value, format_value(result), disabled: true
    elsif result.lab_test_values?
      r.text_field :value
    else
      r.collection_select(:lab_test_value_id,
                          LabTest.find(result.lab_test_id).lab_test_values,
                          :id, :stripped_value,
                          include_blank: true) +
        (r.text_field(:value) if result.result_types?)
    end
  end
end
