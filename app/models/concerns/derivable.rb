# frozen_string_literal: true

module Derivable
  extend ActiveSupport::Concern

  def derived_value
    case lab_test_code
    when 'AG'
      na = result_for 'Na'
      cl = result_for 'Cl'
      co2 = result_for 'CO2'
      na - (cl + co2)
    when 'BUNCRER'
      bun = result_for 'BUN'
      crtsa = result_for 'CRTSA'
      bun / crtsa
    when 'CHOLHDLR'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      chol / hdl
    when 'CORT24MT'
      cort24 = result_for 'CORT24'
      uvol24h = result_for 'UVOL24H'
      cort24 * uvol24h / 100
    when 'CRETCLEAR24H'
      urncret = result_for 'URNCRET'
      crtsa = result_for 'CRTSA'
      uvol24h = result_for 'UVOL24H'
      uvol24h * urncret / crtsa / 1440
    when 'LDLHDLR'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      trig = result_for 'TRIG'
      ldl = case unit_for('LDL').downcase
            when 'mg/dl'
              chol - (hdl + trig / 5)
            when 'mmol/l'
              chol - (hdl + trig / 2.2)
            else
              raise
            end
      ldl / hdl
    when 'NHDCH'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      chol - hdl
    when 'GLO'
      tp = result_for 'TP'
      alb = result_for 'ALB'
      tp - alb
    when 'ALBGLO'
      alb = result_for 'ALB'
      a1_glo = result_for 'A1-GLO'
      a2_glo = result_for 'A2-GLO'
      b_glo = result_for 'B-GLO'
      g_glo = result_for 'G-GLO'
      glo1 = a1_glo + a2_glo + b_glo + g_glo
      tp = result_for 'TP'
      glo2 = tp - alb
      glo = glo1.zero? ? glo2 : glo1
      alb / glo
    when 'IBIL'
      tbil = result_for 'TBIL'
      dbil = result_for 'DBIL'
      tbil - dbil
    when 'IM'
      pr = result_for 'PR'
      np = result_for 'NP'
      100 - (pr + np)
    when 'LDL'
      chol = result_for 'CHOL'
      hdl = result_for 'HDL'
      trig = result_for 'TRIG'
      case unit.name.downcase
      when 'mg/dl'
        chol - (hdl + trig / 5)
      when 'mmol/l'
        chol - (hdl + trig / 2.2)
      else
        raise
      end
    when 'MCH'
      hgb = result_for 'HGB'
      rbc = result_for 'RBC'
      hgb / rbc * 10
    when 'MCHC'
      hgb = result_for 'HGB'
      hct = result_for 'HCT'
      hgb * 100 / hct
    when 'MCV'
      hct = result_for 'HCT'
      rbc = result_for 'RBC'
      hct / rbc * 10
    when 'PCT'
      pltc = result_for 'PLTC'
      mpv = result_for 'MPV'
      pltc * mpv / 10_000_000
    when 'NORM'
      abhead = result_for('ABHEAD')
      abhead_v = value_for('ABHEAD')
      abmid = result_for('ABMID')
      abmid_v = value_for('ABMID')
      abmain = result_for('ABMAIN')
      abmain_v = value_for('ABMAIN')
      excesscyt = result_for('EXCESSCYT')
      excesscyt_v = value_for('EXCESSCYT')
      if (abhead.blank? || abmid.blank? ||
          abmain.blank? || excesscyt.blank?) &&
         (abhead_v || abmid_v || abmain_v || excesscyt_v).present?
        abhead_v || abmid_v || abmain_v || excesscyt_v
      else
        100 - (abhead + abmid + abmain + excesscyt)
      end
    when 'TMOTILE'
      pr = result_for 'PR'
      np = result_for 'NP'
      pr + np
    when 'TPU24H'
      uprot24h = result_for 'UPROT24H'
      uvol24h = result_for 'UVOL24H'
      uprot24h * uvol24h / 100
    when 'TSPERM'
      sconc = result_for 'SCONC'
      svol = result_for 'SVOL'
      tsperm = sconc * svol
      tsperm.zero? ? '<0.1' : tsperm
    when 'VLDL'
      trig = result_for 'TRIG'
      0.2 * trig
    when 'UOSMS'
      na = result_for 'Na'
      bun = result_for 'BUN'
      glucose = result_for('GLU') || result_for('GLUC')
      na * 2 + bun / 2.8 + glucose / 18
    when 'EGNB'
      crtsa = result_for 'CRTSA'
      if patient.gender == 'F'
        a = -0.329
        k = 0.7
        gender = 1.018
      else
        a = -0.411
        k = 0.9
        gender = 1
      end
      age = accession.patient_age[:years]
      crtsa_k = crtsa / k
      141 * [crtsa_k, 1].min**a * [crtsa_k, 1].max**-1.209 * 0.993**age * gender
    when 'EGFRMDRD'
      crtsa = result_for 'CRTSA'
      age = accession.patient_age[:years]
      gender = patient.gender == 'F' ? 0.742 : 1
      175 * crtsa**-1.154 * age**-0.203 * gender
    when 'EGBL'
      crtsa = result_for 'CRTSA'
      if patient.gender == 'F'
        a = -0.329
        k = 0.7
        b_gender = 1.018 * 1.159
      else
        a = -0.411
        k = 0.9
        b_gender = 1.159
      end
      age = accession.patient_age[:years]
      crtsa_k = crtsa / k
      141 * [crtsa_k, 1].min**a * [crtsa_k, 1].max**-1.209 * 0.993**age * b_gender
    when 'EGFRMDRDBL'
      crtsa = result_for 'CRTSA'
      age = accession.patient_age[:years]
      gender = patient.gender == 'F' ? 0.742 : 1
      175 * crtsa**-1.154 * age**-0.203 * gender * 1.212
    end
  rescue StandardError
    nil
  end

  def result_for(code)
    lab_test_by_code = LabTest.find_by(code: code)
    result_value = accession.results.find_by(lab_test_id: lab_test_by_code).try(:value)
    result_value.to_d if result_value.present?
  end

  def unit_for(code)
    lab_test_by_code = LabTest.find_by(code: code)
    unit_for_lab_test = accession.results.find_by(lab_test_id: lab_test_by_code).unit.name
    unit_for_lab_test.presence
  end

  def value_for(code)
    lab_test_by_code = LabTest.find_by(code: code)
    value_for_lab_test = accession.results.find_by(lab_test_id: lab_test_by_code).lab_test_value
    value_for_lab_test.value if value_for_lab_test.present?
  end
end
