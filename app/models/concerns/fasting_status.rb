# frozen_string_literal: true

module FastingStatus
  extend ActiveSupport::Concern

  included do
    attr_writer :fasting_status_duration_iso8601

    before_save :save_fasting_status_duration_iso8601

    validate :validate_iso8601_duration

    def fasting_status_duration_iso8601
      @fasting_status_duration_iso8601 || fasting_status_duration&.iso8601
    end

    def save_fasting_status_duration_iso8601
      if @fasting_status_duration_iso8601.present?
        self.fasting_status_duration = ActiveSupport::Duration.parse(@fasting_status_duration_iso8601)
      else
        self.fasting_status_duration = nil
      end
    end

    private

    def validate_iso8601_duration
      if @fasting_status_duration_iso8601.present? && ActiveSupport::Duration.parse(@fasting_status_duration_iso8601).nil?
        errors.add(:fasting_status_duration_iso8601, I18n.t('errors.messages.invalid'))
      end
    rescue ActiveSupport::Duration::ISO8601Parser::ParsingError
      errors.add(:fasting_status_duration_iso8601, I18n.t('errors.messages.invalid'))
    end
  end
end
