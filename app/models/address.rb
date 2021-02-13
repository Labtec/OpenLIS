# frozen_string_literal: true

class Address
  # https://www.iso.org/obp/ui/#iso:code:3166:PA
  PROVINCES = %i[1 2 3 4 5 6 7 8 9 10].freeze
  COMARCAS = %i[em ky xx nb].freeze
  SUBDIVISIONS ||= YAML.load_file('app/models/subdivisions.yml')
end
