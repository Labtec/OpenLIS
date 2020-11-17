# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :lab_tests, -> { order('position ASC') }, dependent: :destroy
  has_many :accessions, through: :lab_tests
  has_many :observations, through: :lab_tests
  has_many :notes, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  auto_strip_attributes :code, :loinc_class, :name

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
