module QuoteVersionConcerns
  extend ActiveSupport::Concern

  included do
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

    def unarchive_quotes
      if versions.empty?
        return unless parent_quote

        parent_quote.versions.each do |quote_version|
          quote_version.approved!
        end
        parent_quote.approved!
      else
        versions.each do |quote_version|
          quote_version.approved!
        end
      end
    end
  end
end
