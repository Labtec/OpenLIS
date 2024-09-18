# frozen_string_literal: true

module ObservationsHelper
  def doctor_name(doctor)
    if doctor
      t(".doctor")
      tag.strong(doctor.name)
    else
      tag.strong(t(".outpatient"))
    end
  end

  def format_value(observation)
    if observation.lab_test.derivation?
      number_with_precision(observation.derived_value, precision: observation.lab_test_decimals, delimiter: ",") || "calc."
    elsif observation.value_codeable_concept.present? && observation.value.present?
      [ observation.value_codeable_concept,
        " [",
        number_with_precision(observation.value, precision: observation.lab_test_decimals, delimiter: ","),
        "]" ].join
    elsif observation.value_codeable_concept.present?
      observation.value_codeable_concept
    elsif observation.value.blank?
      "pend."
    elsif observation.lab_test.ratio?
      observation.value.tr(":", "∶")
    elsif observation.lab_test.range?
      observation.value.tr("-", "–")
    elsif observation.lab_test.fraction?
      observation.value.gsub(%r{/}, " ∕ ")
    elsif observation.lab_test.text_length?
      observation.value
    else
      observation.value_quantity_comparator.to_s +
        number_with_precision(observation.value_quantity, precision: observation.lab_test_decimals, delimiter: ",")
    end
  end

  def format_units(observation)
    observation.value_unit
  end

  def flag_name(observation)
    case observation.interpretation
    when "<"
      t("results.off_scale_low")
    when ">"
      t("results.off_scale_high")
    when "A"
      t("results.abnormal")
    when "AA"
      t("results.critical_abnormal")
    when "DET"
      t("results.detected")
    when "E"
      t("results.equivocal")
    when "H"
      t("results.high")
    when "HU"
      t("results.significantly_high")
    when "HH"
      t("results.critical_high")
    when "I"
      t("results.intermediate")
    when "IND"
      t("results.indeterminate")
    when "L"
      t("results.low")
    when "LU"
      t("results.significantly_low")
    when "LL"
      t("results.critical_low")
    when "N"
      t("results.normal")
    when "ND"
      t("results.not_detected")
    when "NEG"
      t("results.negative")
    when "NR"
      t("results.non_reactive")
    when "NS"
      t("results.non_susceptible")
    when "POS"
      t("results.positive")
    when "R"
      t("results.resistant")
    when "RR"
      t("results.reactive")
    when "S"
      t("results.susceptible")
    when "WR"
      t("results.weakly_reactive")
    end
  end

  def flag_color(interpretation)
    case interpretation
    when *LabTestValue::ABNORMAL_FLAGS
      "abnormal_value"
    when *LabTestValue::HIGH_FLAGS
      "high_value"
    when *LabTestValue::LOW_FLAGS
      "low_value"
    else
      "normal_value"
    end
  end

  def ranges_table(intervals, display_gender: false)
    return [ [ nil, nil, nil, nil, nil ] ] if intervals.empty?

    table = []
    intervals.each do |interval|
      table << range_row(interval, display_gender: display_gender)
    end
    table
  end

  def range_row(interval, display_gender: false)
    return [ nil, nil, nil, nil, nil ] unless interval

    gender = display_gender && interval.gender ? t(interval.gender, scope: "interval.gender") : ""
    condition = "#{interval.condition}:" if interval.condition.present?
    symbol = range_symbol(interval.range)
    if interval.lab_test.ratio? # XXX: titer
      left_side = "1∶#{number_with_precision(interval.range_low_value, precision: 0, delimiter: ',')}" if interval.range_low_value && interval.range_high_value
      right_side = if interval.range_high_value
                     "1∶#{number_with_precision(interval.range_high_value, precision: 0, delimiter: ',')}"
      else
                     "1∶#{number_with_precision(interval.range_low_value, precision: 0, delimiter: ',')}"
      end
    else
      left_side = number_with_precision(interval.range_low_value, precision: interval.lab_test.decimals.to_i, delimiter: ",") if interval.range_low_value && interval.range_high_value
      right_side = if interval.range_high_value
                     number_with_precision(interval.range_high_value, precision: interval.lab_test.decimals.to_i, delimiter: ",")
      else
                     number_with_precision(interval.range_low_value, precision: interval.lab_test.decimals.to_i, delimiter: ",")
      end
    end
    [ condition, gender, left_side, symbol, right_side ]
  end

  def registration_number(inline: false)
    return "" if current_user.register.blank?

    "#{inline ? ' / ' : ''}#{t('results.index.register')} #{current_user.register}"
  end

  def observation_input(builder, observation, lab_test)
    if lab_test.derivation?
      text_field_tag :value, format_value(observation), disabled: true
    elsif lab_test.lab_test_values.empty?
      builder.text_field :value
    else
      builder.collection_select(:lab_test_value_id,
                                lab_test.lab_test_values.sorted,
                                :id, :stripped_value,
                                include_blank: true) +
        (builder.text_field(:value) if result_types?(lab_test))
    end
  end

  # value -> value_quantity, value_integer
  # lab_test_value -> value_codeable_concept
  # also_numeric -> multiple_results_allowed
  # range -> value_range
  # ratio -> value_ratio
  # fraction -> value_ratio
  # text_length -> value_string
  def result_types?(lab_test)
    lab_test.also_numeric? ||
      lab_test.ratio? || lab_test.range? || lab_test.fraction? || lab_test.text_length.present?
  end

  def not_performed_class(not_performed)
    "not-performed" if not_performed
  end

  def row_class
    cycle("even", "odd", name: "alternating_row_colors")
  end

  def display_units(observation)
    !observation.lab_test_value || observation.lab_test_value&.numeric? || observation.value.present?
  end
end
