# frozen_string_literal: true

class Cedula
  def initialize(ruc)
    @ruc = ruc
  end

  def dv
    return unless @ruc

    split_ruc = @ruc.split("-")

    return if (split_ruc.size == 4 && !%w[NT AV PI].include?(split_ruc[1])) ||
              split_ruc.size < 3 ||
              split_ruc.size > 5

    normalized_ruc = normalize_ruc(split_ruc)

    # XXX: Persona Natural, replace N with 5
    padded_ruc = ("5" +
       normalized_ruc[0].rjust(4, "0") +
       normalized_ruc[1].rjust(3, "0") +
       normalized_ruc[2].rjust(5, "0")).rjust(20, "0")

    dv1 = calculate_dv(padded_ruc)
    dv2 = calculate_dv(padded_ruc + dv1.to_s)

    "#{dv1}#{dv2}"
  end

  private

  def calculate_dv(padded_ruc)
    # modulo 11 check digit
    weight = padded_ruc.split("").map(&:to_i)
                       .zip(Array(2..padded_ruc.size + 1).reverse)
                       .map { |x, y| x * y }

    mod11 = weight.sum % 11
    return 11 - mod11 if mod11 > 1

    0
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
