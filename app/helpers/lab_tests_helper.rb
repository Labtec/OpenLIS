# frozen_string_literal: true

module LabTestsHelper
  def name_with_description(lab_test)
    if lab_test.description.present?
      sanitize "#{lab_test.name} (#{lab_test.description})"
    else
      sanitize lab_test.name
    end
  end
end
