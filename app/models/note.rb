# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :department
  belongs_to :noticeable, polymorphic: true

  normalizes :content, with: ->(content) { content.strip }
end
