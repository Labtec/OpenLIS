module ResultsHelper
  def patient_age_at accession
    case
    when accession.patient_age_in_days < 31
      pluralize accession.patient_age[:days], t('patients.day')
    when accession.patient_age_in_days < 365
      pluralize accession.patient_age[:months], t('patients.month')
    else
      pluralize accession.patient_age[:years], t('patients.year')
    end
  end

  def doctor_name doctor
    if doctor
      t('.doctor')
      content_tag :strong, doctor.name
    else
      content_tag :strong, t('.walk_in')
    end
  end

  def format_value(result)
    if result.lab_test.derivation?
      number_with_precision(result.derived_value, precision: result.lab_test.decimals, delimiter: ',')
    elsif result.lab_test_value && !result.value.blank?
      result.lab_test_value.value +
      ' [' +
      number_with_precision(result.value, precision: result.lab_test.decimals, delimiter: ',') +
      ']'
    elsif result.lab_test_value
      result.lab_test_value.value
    elsif result.value.blank?
      'pend.'
    elsif result.lab_test.ratio?
      result.value.gsub(/[:]/, '&ratio;')
    elsif result.lab_test.range?
      result.value.gsub(/[-]/, '&ndash;')
    elsif result.lab_test.fraction?
      result.value.gsub(/[\/]/, ' &frasl;&thinsp;')
    elsif result.lab_test.text_length?
      result.value
    else
      number_with_precision(result.value, precision: result.lab_test.decimals, delimiter: ',')
    end
  end

  def flag_name result
    case result.flag
    when "A"
      t('results.abnormal')
    when "H"
      t('results.high')
    when "L"
      t('results.low')
    end
  end

  def flag_color result
    case result.flag
    when "A"
      "abnormal_value"
    when "H"
      "high_value"
    when "L"
      "low_value"
    else
      "normal_value"
    end
  end

  def ranges_table ranges
    tbody = content_tag :tbody do
      ranges.collect { |range|
        content_tag :tr do
          content_tag :td, safe_join(range), class: 'range'
        end
      }.join().html_safe
    end
    content_tag :table, sanitize(tbody)
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
end
