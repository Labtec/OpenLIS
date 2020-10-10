# frozen_string_literal: true

# https://wiki.openmrs.org/display/docs/Check+Digit+Algorithm
class Luhn
  VALID_CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVYWXZ_'

  class InvalidIDException < StandardError; end

  def self.checkdigit(id_without_checkdigit)
    id_without_checkdigit = id_without_checkdigit.strip.upcase
    weight = id_without_checkdigit.reverse.each_char.with_index.map do |ch, i|
      raise InvalidIDException, "#{ch} is an invalid character" unless VALID_CHARS.include?(ch)

      digit = ch.ord - 48
      i.even? ? 2 * digit - digit / 5 * 9 : digit
    end
    sum = weight.sum.abs + 10
    (10 - sum % 10) % 10
  end
end
