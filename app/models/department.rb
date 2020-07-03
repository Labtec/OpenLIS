# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :lab_tests, dependent: :destroy
  has_many :notes, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  auto_strip_attributes :name

  after_commit :flush_cache

  def self.cached_tests
    Rails.cache.fetch([name, 'cached_tests']) do
      order('id asc').includes(:lab_tests).to_a
    end
  end

  private

  def flush_cache
    Rails.cache.delete([self.class.name, 'cached_tests'])
  end
end
