# frozen_string_literal: true

class Cedula
  def self.dv(ruc)
    split_ruc = ruc.split('-')

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

  def self.calculate_dv(padded_ruc)
    j = 2
    nsuma = 0

    padded_ruc.reverse.split('').each do |k|
      nsuma += j * k.to_i
      j += 1
    end

    r = nsuma % 11

    return 11 - r if r > 1

    0
  end

  # TODO EE, SB
  def self.normalize_ruc(split_ruc)
    # Normalize split_ruc when NT
    if split_ruc.size == 4 && split_ruc[1] == 'NT'
      ["#{split_ruc[0]}43", split_ruc[2], split_ruc[3]] # When Numero Tributario, replace with 43
    elsif split_ruc.size == 4 && split_ruc[1] == 'AV'
      ["#{split_ruc[0]}15", split_ruc[2], split_ruc[3]] # When Antes de la Vigencia, replace with 15
    elsif split_ruc.size == 4 && split_ruc[1] == 'PI'
      ["#{split_ruc[0]}79", split_ruc[2], split_ruc[3]] # When Panameno Indigena, replace with 79
    else
      split_ruc[0] = case split_ruc[0]
                     when 'E', 'N'  # Extranjero, Naturalizado
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
