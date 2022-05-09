# frozen_string_literal: true

module Broadcastable
  module Patient
    extend ActiveSupport::Concern

    included do
      #after_create_commit -> { broadcast_prepend_later_to :patients, partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.patients_path } }

      after_update_commit -> { broadcast_replace_later_to [true, :patients], partial: 'patients/admin_patient' }
      after_update_commit -> { broadcast_replace_later_to [false, :patients] }
      after_update_commit -> { broadcast_replace_later_to :patient_card, partial: 'patients/card', locals: { patient: self }, target: "patient_#{id}_card" }
      after_update_commit -> { broadcast_replace_later_to :patient_name, partial: 'patients/name', locals: { patient: self }, target: "patient_#{id}_name" }
      #after_update_commit -> { broadcast_replace_later_to :patient, partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.patient_path(self) }, target: :patient }

      after_destroy_commit -> { broadcast_remove_to [true, :patients] }
      after_destroy_commit -> { broadcast_remove_to [false, :patients] }
      after_destroy_commit -> { broadcast_remove_to :patient_card, target: "patient_#{id}_card" }
      after_destroy_commit -> { broadcast_remove_to :patient_name, target: "patient_#{id}_name" }
      #after_destroy_commit -> { broadcast_replace_to :patient, partial: 'layouts/invalid', locals: { path: Rails.application.routes.url_helpers.patients_path }, target: :patient }
    end
  end
end
