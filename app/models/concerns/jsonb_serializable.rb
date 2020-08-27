# frozen_string_literal: true

module JsonbSerializable
  extend ActiveSupport::Concern

  class_methods do
    def load(json)
      return new if json.blank?

      new(JSON.parse(json))
    end

    def dump(obj)
      raise StandardError, "Expected #{self}, got #{obj.class}" unless obj.respond_to? :to_json

      obj.to_json
    end
  end
end
