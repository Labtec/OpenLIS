# frozen_string_literal: true

class QualifiedValue < ApplicationRecord
  ANIMAL_SPECIES = (0..3).to_a
  RANGE_CATEGORIES = %w[reference critical absolute].freeze
  GENDERS = %w[male female other unkwown].freeze

  belongs_to :lab_test
  belongs_to :interpretation, class_name: 'LabTestValue', optional: true

  acts_as_list column: :rank, scope: :lab_test_id

  # TODO: Migrate Patient -> Person-Patient.administrative_gender
  # scope :for_gender, ->(gender) { where(gender: [gender, nil]) }
  scope :for_gender, (lambda do |gender|
    case gender
    when 'F'
      where(gender: ['female', nil])
    when 'M'
      where(gender: ['male', nil])
    end
  end)
  scope :for_species, ->(type) { where(animal_type: type) }
  # NOTE: Compatible with PostgreSQL's [) ranges
  scope :for_age, (lambda do |age|
    return unless age

    where(age_low: nil, age_high: nil).or(
      where(
        arel_age_interval(age).gteq(arel_age_low).and(arel_age_high.gt(arel_age_interval(age))).or(
          arel_age_interval(age).gteq(arel_age_low).and(arel_table[:age_high].eq(nil))
        ).or(
          arel_table[:age_low].eq(nil).and(arel_age_high.gt(arel_age_interval(age)))
        )
      )
    )
  end)
  scope :for_subject, ->(patient) { for_species(patient.animal_type).for_gender(patient.gender) }
  scope :for_result, ->(accession) { for_subject(accession.patient).for_age(accession.subject_age) }
  scope :female, -> { where(gender: [nil, 'female']) }
  scope :male, -> { where(gender: [nil, 'male']) }
  scope :reference, -> { where(range_category: [nil, 'reference']) }
  scope :critical, -> { where(range_category: 'critical') }
  scope :absolute, -> { where(range_category: 'absolute') }
  scope :normal, -> { where(context: [nil, 'normal']) }
  scope :therapeutic, -> { where(context: 'therapeutic') }
  scope :treatment, -> { where(context: 'treatment') }
  scope :pre_puberty, -> { where(context: 'pre-puberty') }
  scope :follicular, -> { where(context: 'follicular') }
  scope :midcycle, -> { where(context: 'midcycle') }
  scope :luteal, -> { where(context: 'luteal') }
  scope :postmenopausal, -> { where(context: 'postmenopausal') }
  scope :endocrine, -> { pre_puberty.or(follicular).or(midcycle).or(luteal).or(postmenopausal) }
  scope :ranked, -> { order(rank: :asc) }

  validates :animal_type, inclusion: { in: ANIMAL_SPECIES }, allow_nil: true
  validates :gender, inclusion: { in: GENDERS }, allow_nil: true

  after_create_commit -> { broadcast_prepend_later_to 'admin:qualified_values', partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.admin_qualified_values_path } }
  after_update_commit -> { broadcast_replace_later_to 'admin:qualified_values' }
  after_destroy_commit -> { broadcast_remove_to 'admin:qualified_values' }

  auto_strip_attributes :range_category,
                        :range_low_value, :range_high_value,
                        :context,
                        :gender,
                        :age_low, :age_high,
                        :gestational_age_low, :gestational_age_high,
                        :condition

  def self.arel_age_high
    Arel::Nodes::NamedFunction.new('CAST', [Arel.sql('"age_high" AS INTERVAL')])
  end

  def self.arel_age_interval(age)
    Arel.sql("INTERVAL '#{sanitize_sql(age.iso8601)}'") if age
  end

  def self.arel_age_low
    Arel::Nodes::NamedFunction.new('CAST', [Arel.sql('"age_low" AS INTERVAL')])
  end

  def absolute?
    range_category == 'absolute'
  end

  def age
    return Range.new(nil, duration_parse(age_high), true) if age_low.nil?

    Range.new(duration_parse(age_low), duration_parse(age_high))
  end

  def critical?
    range_category == 'critical'
  end

  def female?
    gender == 'female'
  end

  def gestational_age
    return Range.new(nil, duration_parse(gestational_age_high), true) if gestational_age_low.nil?

    Range.new(duration_parse(gestational_age_low), duration_parse(gestational_age_high))
  end

  def male?
    gender == 'male'
  end

  def range
    return Range.new(nil, range_high_value, true) if range_low_value.nil?

    Range.new(range_low_value, range_high_value)
  end

  def reference?
    range_category.nil? || range_category == 'reference'
  end

  def to_partial_path
    'admin/qualified_values/qualified_value'
  end

  private

  def duration_parse(duration)
    return unless duration

    ActiveSupport::Duration.parse duration
  rescue ActiveSupport::Duration::ISO8601Parser::ParsingError
    nil
  end
end
