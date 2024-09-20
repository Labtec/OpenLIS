# frozen_string_literal: true

module LabTestsHelper
  def name_with_description(lab_test)
    if lab_test.description.present?
      sanitize "#{lab_test.name} (#{lab_test.description})"
    else
      sanitize lab_test.name
    end
  end

  def loinc_hyperlink(loinc)
    return if loinc.blank?

    link_to loinc, "https://s.details.loinc.org/LOINC/#{loinc}.html?sections=Comprehensive", target: :_blank, rel: :noopener
  end
end
