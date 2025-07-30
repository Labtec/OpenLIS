# frozen_string_literal: true

class Cedula
  REGEXP = /\A(([2-9]|1[0-3]?)(?:AV|PI|-(NT))?|E|N|PE)-(\d{1,4})-(\d{1,6})\z/

  def initialize(ruc)
    @ruc = ruc
  end

  def dv
    return unless @ruc

    split_ruc = @ruc.split("-")

    return if (split_ruc.size == 4 && %w[NT AV PI SB].exclude?(split_ruc[1])) ||
              split_ruc.size < 3 ||
              split_ruc.size > 5

    normalized_ruc = normalize_ruc(split_ruc)

    # XXX: Persona Natural, replace N with 5
    padded_ruc = ("5" +
       normalized_ruc[0].rjust(4, "0") +
       normalized_ruc[1].rjust(3, "0") +
       normalized_ruc[2].rjust(5, "0")).rjust(20, "0")

    dv1 = calculate_dv(padded_ruc)
    # Add the check digit (dv1), to the extreme right (low order) position of
    # the base number of the padded RUC, and calculate its check digit:
    dv2 = calculate_dv(padded_ruc + dv1.to_s)

    "#{dv1}#{dv2}"
  end

  private

  # The purpose of a check digit (DV) is to guard against errors caused by the
  # incorrect transcription of an RUC.  The modulus 11 basis using the weighting
  # factors +padded_ruc.size+ plus 1 to 2 for calculating the check digit is one
  # of the most efficient systems for detecting transcription errors.
  #
  # The procedure for calculating the check digit, is as follows (8-1-1):
  #
  # 1. Take the digits of the +padded_ruc+ (N-8-1-1):
  #      0, 0, 0, 0, 0, 0, 0, 5, 0, 8, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1
  # 2. Take the weighting factors associated with each digit:
  #      21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2
  # 3. Multiply each digit in turn by its weighting factor:
  #      0, 0, 0, 0, 0, 0, 0, 70, 0, 96, 0, 0, 0, 0, 7, 0, 0, 0, 0, 2
  # 4. Add these numbers together:
  #      175
  # 5. Divide this sum by the modulus 11:
  #      175 % 11 = 10
  # 6. Substract the remainder from 11.  If the remainder was 1, or if there was
  #    no remainder, return zero as the check digit:
  #      11 - 10 = 1
  def calculate_dv(padded_ruc)
    weight = padded_ruc.chars.map(&:to_i)
                       .zip(Array(2..padded_ruc.size + 1).reverse)
                       .map { |x, y| x * y }
    mod11 = weight.sum % 11
    mod11.zero? || mod11 == 1 ? 0 : 11 - mod11
  end

  # TODO: EE, SB?
  def normalize_ruc(split_ruc)
    if split_ruc.size == 4
      split_ruc[0] = case split_ruc[1]
                     when "NT" # Numero Tributario
                       "#{split_ruc[0]}43"
                     when "AV" # Antes de la Vigencia
                       "#{split_ruc[0]}15"
                     when "PI" # Panameno Indigena
                       "#{split_ruc[0]}79"
                     when "SB" # TODO: SB = 81 ?
                       "#{split_ruc[0]}81"
                     end
      [ split_ruc[0], split_ruc[2], split_ruc[3] ]
    else
      split_ruc[0] = case split_ruc[0]
                     when "E" # Extranjero
                       "50"
                     when "N" # Naturalizado
                       "40"
                     when "PE" # Panameno Extranjero
                       "75"
                     else
                       "#{split_ruc[0]}00"
                     end
      split_ruc
    end
  end
end
