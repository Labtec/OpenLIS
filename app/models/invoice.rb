# frozen_string_literal: true

# https://dgi-fep.mef.gob.pa/
class Invoice
  DISCOUNT = 0.2 # TODO: Conditionalize per customer

  def initialize(claims)
    @claims = claims
  end

  # TODO: Download as .xlsx
  def csv
    csv = ['Descripción,Información de Interés,Cantidad,Precio Unitario,Descuento (opcional),Tasa ITBMS,Tasa ISC (opcional),Monto ISC (opcional),Cód CPBS (opcional) ,Cód Sub CPBS (Opcional),']
    @claims.each do |claim|
      csv << %Q{"Lab Tests: #{claim.cpt_codes.join(', ')}","Insured ID: #{claim.insured_name.policy_number}. Our Reference #{claim.external_number}. Your Reference: #{claim.number}",1.00,#{claim.total_price},#{claim.total_price * DISCOUNT},0.00,0.00,0.00,85,8510,}
    end

    csv.join("\n")
  end
end
