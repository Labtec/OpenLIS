# frozen_string_literal: true

class Address
  include JsonbSerializable
  include Addresseable
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Attributes
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend ActiveModel::Naming
  # extend AutoStripAttributes

  # https://www.iso.org/obp/ui/#iso:code:3166:PA
  PROVINCES = %i[1 2 3 4 5 6 7 8 9 10].freeze
  COMARCAS = %i[em ky nb].freeze
  SUBDIVISIONS ||= YAML.load_file('app/models/subdivisions.yml')

  attr_accessor :line

  # https://www.hl7.org/fhir/datatypes.html#address
  attribute :province, :string
  attribute :district, :string
  attribute :corregimiento, :string
  attribute :line, :string # , array: true, default: []

  alias to_hash serializable_hash

  # XXX: hand-rolled auto_strip_attributes
  def line=(line)
    @line = line.squish
  end

  def persisted?
    false
  end

  def id
    nil
  end
end
