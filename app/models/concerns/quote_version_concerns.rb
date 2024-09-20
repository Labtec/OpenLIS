# frozen_string_literal: true

module QuoteVersionConcerns
  extend ActiveSupport::Concern

  included do
    belongs_to :parent_quote, optional: true, class_name: "Quote"

    has_many :versions, class_name: "Quote", foreign_key: :parent_quote_id, dependent: :destroy

    validates :version_number, presence: true, if: -> { parent_quote_id.present? },
                               uniqueness: { scope: [ :parent_quote_id ] }

    before_validation :add_version_number, on: :create

    def archive_other_versions
      if versions.empty?
        return unless parent_quote

        parent_quote.versions.each do |quote_version|
          quote_version.archived! unless quote_version == self
        end
        parent_quote.archived! unless parent_quote == self
      else
        versions.each do |quote_version|
          quote_version.archived! unless quote_version == self
        end
      end
    end

    def last_version?
      return true unless parent_quote

      parent_quote.versions.last == self
    end

    def last_version_number
      parent_quote.try(:versions).try(:last).try(:version_number).to_i
    end

    def unarchive_quotes
      if versions.empty?
        return unless parent_quote

        parent_quote.versions.each(&:approved!)
        parent_quote.approved!
      else
        versions.each(&:approved!)
      end
    end

    private

    def add_version_number
      return unless parent_quote

      self.version_number = last_version_number + 1
    end
  end
end
