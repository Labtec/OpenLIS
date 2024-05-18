# frozen_string_literal: true

class Cedula
  def initialize(ruc)
    @ruc = ruc
  end

  def dv
    return unless @ruc

    split_ruc = @ruc.split('-')

    return if (split_ruc.size == 4 && !['NT', 'AV', 'PI'].include?(split_ruc[1])) || split_ruc.size < 3 || split_ruc.size > 5

    normalized_ruc = normalize_ruc(split_ruc)

    # XXX: Persona Natural, replace N with 5
    padded_ruc = ('5' +
       normalized_ruc[0].rjust(4, '0') +
       normalized_ruc[1].rjust(3, '0') +
       normalized_ruc[2].rjust(5, '0')).rjust(20, '0')

    dv1 = calculate_dv(padded_ruc)
    dv2 = calculate_dv(padded_ruc + dv1.to_s)

    "#{dv1}#{dv2}"
  end

  private

  def calculate_dv(padded_ruc)
    # modulo 11 (kind of)
    weighted_sum = padded_ruc.split('').map(&:to_i).
          zip(Array(2..padded_ruc.size + 1).reverse).map{ |x, y| x * y }.inject(:+) % 11

    return 11 - weighted_sum if weighted_sum > 1

    0
  end

  # TODO EE, SB
  def normalize_ruc(split_ruc)
    if split_ruc.size == 4 && split_ruc[1] == 'NT'
      ["#{split_ruc[0]}43", split_ruc[2], split_ruc[3]] # When Numero Tributario, replace with 43
    elsif split_ruc.size == 4 && split_ruc[1] == 'AV'
      ["#{split_ruc[0]}15", split_ruc[2], split_ruc[3]] # When Antes de la Vigencia, replace with 15
    elsif split_ruc.size == 4 && split_ruc[1] == 'PI'
      ["#{split_ruc[0]}79", split_ruc[2], split_ruc[3]] # When Panameno Indigena, replace with 79
    else
      split_ruc[0] = case split_ruc[0]
                     when 'E', 'N' # Extranjero, Naturalizado
                       '50'
                     when 'PE' # Panameno Extranjero
                       '75'
                     else
                       "#{split_ruc[0]}00"
                     end
      split_ruc
    end
  end
end
