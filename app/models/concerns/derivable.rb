# frozen_string_literal: true

module Derivable
  extend ActiveSupport::Concern

  def derived_value_for(code)
    case code
    when 'AG'
      na = result_value_quantity_for 'Na'
      cl = result_value_quantity_for 'Cl'
      co2 = result_value_quantity_for 'CO2'
      na - (cl + co2)
    when 'BUNCRER'
      bun = result_value_quantity_for 'BUN'
      crtsa = result_value_quantity_for 'CRTSA'
      bun / crtsa
    when 'CLDL1'
      tc = result_value_quantity_for 'CHOL'
      hdl = result_value_quantity_for 'HDL'
      tg = result_value_quantity_for 'TRIG'
      case LabTest.unit_for('CLDL1').downcase
      when 'mg/dl'
        return if tg > 800

        ldl = (tc / 0.948) - (hdl / 0.971) - ((tg / 8.56) + ((tg * (tc - hdl)) / 2140) - (tg**2 / 16_100)) - 9.44
        ldl < 15 ? '<15' : ldl
      when 'mmol/l'
        return if tg > 9.03

        ldl = (tc / 0.948) - (hdl / 0.971) - ((tg / 3.74) + ((tg * (tc - hdl)) / 24.16) - (tg**2 / 79.36)) - 0.244
        ldl < 0.4 ? '<0.4' : ldl
      else
        raise
      end
    when 'CLDL1HDLR'
      tc = result_value_quantity_for 'CHOL'
      hdl = result_value_quantity_for 'HDL'
      tg = result_value_quantity_for 'TRIG'
      case LabTest.unit_for('CLDL1').downcase
      when 'mg/dl'
        return if tg > 800

        ldl = (tc / 0.948) - (hdl / 0.971) - ((tg / 8.56) + ((tg * (tc - hdl)) / 2140) - (tg**2 / 16_100)) - 9.44
        ldl < 15 ? 15 : ldl
      when 'mmol/l'
        return if tg > 9.03

        ldl = (tc / 0.948) - (hdl / 0.971) - ((tg / 3.74) + ((tg * (tc - hdl)) / 24.16) - (tg**2 / 79.36)) - 0.244
        ldl < 0.4 ? 0.4 : ldl
      else
        raise
      end
      ldl / hdl
    when 'CHOLHDLR'
      chol = result_value_quantity_for 'CHOL'
      hdl = result_value_quantity_for 'HDL'
      chol / hdl
    when 'CORT24MT'
      cort24 = result_value_quantity_for 'CORT24'
      uvol24h = result_value_quantity_for 'UVOL24H'
      cort24 * uvol24h / 100
    when 'CRETCLEAR24H'
      urncret = result_value_quantity_for 'URNCRET'
      crtsa = result_value_quantity_for 'CRTSA'
      uvol24h = result_value_quantity_for 'UVOL24H'
      uvol24h * urncret / crtsa / 1440
    when 'LDLHDLR'
      chol = result_value_quantity_for 'CHOL'
      hdl = result_value_quantity_for 'HDL'
      trig = result_value_quantity_for 'TRIG'
      ldl = case LabTest.unit_for('LDL').downcase
            when 'mg/dl'
              chol - (hdl + trig / 5)
            when 'mmol/l'
              chol - (hdl + trig / 2.2)
            else
              raise
            end
      ldl / hdl
    when 'TRIGHDLR'
      hdl = result_value_quantity_for 'HDL'
      trig = result_value_quantity_for 'TRIG'
      trig / hdl
    when 'NHDCH'
      chol = result_value_quantity_for 'CHOL'
      hdl = result_value_quantity_for 'HDL'
      chol - hdl
    when 'GLO'
      tp = result_value_quantity_for 'TP'
      alb = result_value_quantity_for 'ALB'
      tp - alb
    when 'ALBGLO'
      alb = result_value_quantity_for 'ALB'
      a1_glo = result_value_quantity_for 'A1-GLO'
      a2_glo = result_value_quantity_for 'A2-GLO'
      b_glo = result_value_quantity_for 'B-GLO'
      g_glo = result_value_quantity_for 'G-GLO'
      glo1 = a1_glo + a2_glo + b_glo + g_glo
      tp = result_value_quantity_for 'TP'
      glo2 = tp - alb
      glo = glo1.zero? ? glo2 : glo1
      alb / glo
    when 'ElphAlb'
      prot = result_value_quantity_for 'ElphProt'
      albp = result_value_quantity_for 'ElphAlb%'
      prot * albp / 100
    when 'ElphAlbGlob'
      albp = result_value_quantity_for 'ElphAlb%'
      alpha1p = result_value_quantity_for 'ElphAlpha1%'
      alpha2p = result_value_quantity_for 'ElphAlpha2%'
      beta1p = result_value_quantity_for 'ElphBeta1%'
      beta2p = result_value_quantity_for 'ElphBeta2%'
      gammap = result_value_quantity_for 'ElphGamma%'
      albp / (alpha1p + alpha2p + beta1p + beta2p + gammap)
    when 'ElphAlpha1'
      prot = result_value_quantity_for 'ElphProt'
      alpha1p = result_value_quantity_for 'ElphAlpha1%'
      prot * alpha1p / 100
    when 'ElphAlpha2'
      prot = result_value_quantity_for 'ElphProt'
      alpha2p = result_value_quantity_for 'ElphAlpha2%'
      prot * alpha2p / 100
    when 'ElphBeta1'
      prot = result_value_quantity_for 'ElphProt'
      beta1p = result_value_quantity_for 'ElphBeta1%'
      prot * beta1p / 100
    when 'ElphBeta2'
      prot = result_value_quantity_for 'ElphProt'
      beta2p = result_value_quantity_for 'ElphBeta2%'
      prot * beta2p / 100
    when 'ElphGamma'
      prot = result_value_quantity_for 'ElphProt'
      gammap = result_value_quantity_for 'ElphGamma%'
      prot * gammap / 100
    when 'IBIL'
      tbil = result_value_quantity_for 'TBIL'
      dbil = result_value_quantity_for 'DBIL'
      tbil - dbil
    when 'IM'
      pr = result_value_quantity_for 'PR'
      np = result_value_quantity_for 'NP'
      100 - (pr + np)
    when 'LDL'
      chol = result_value_quantity_for 'CHOL'
      hdl = result_value_quantity_for 'HDL'
      trig = result_value_quantity_for 'TRIG'
      case LabTest.unit_for('LDL').downcase
      when 'mg/dl'
        chol - (hdl + trig / 5)
      when 'mmol/l'
        chol - (hdl + trig / 2.2)
      else
        raise
      end
    when 'MCH'
      hgb = result_value_quantity_for 'HGB'
      rbc = result_value_quantity_for 'RBC'
      hgb / rbc * 10
    when 'MCHC'
      hgb = result_value_quantity_for 'HGB'
      hct = result_value_quantity_for 'HCT'
      hgb * 100 / hct
    when 'MCV'
      hct = result_value_quantity_for 'HCT'
      rbc = result_value_quantity_for 'RBC'
      hct / rbc * 10
    when 'NORM'
      abhead = result_value_quantity_for('ABHEAD')
      abhead_v = result_value_codeable_concept_for('ABHEAD')
      abmid = result_value_quantity_for('ABMID')
      abmid_v = result_value_codeable_concept_for('ABMID')
      abmain = result_value_quantity_for('ABMAIN')
      abmain_v = result_value_codeable_concept_for('ABMAIN')
      excesscyt = result_value_quantity_for('EXCESSCYT')
      excesscyt_v = result_value_codeable_concept_for('EXCESSCYT')
      if (abhead.blank? || abmid.blank? ||
          abmain.blank? || excesscyt.blank?) &&
         (abhead_v || abmid_v || abmain_v || excesscyt_v).present?
        abhead_v || abmid_v || abmain_v || excesscyt_v
      else
        100 - (abhead + abmid + abmain + excesscyt)
      end
    when 'PCT'
      pltc = result_value_quantity_for 'PLTC'
      mpv = result_value_quantity_for 'MPV'
      pltc * mpv / 10_000
    when 'PSA_R'
      fpsa = result_value_quantity_for 'FPSA'
      tpsa = result_value_quantity_for 'TPSA'
      tpsa1d = result_value_quantity_for 'TPSA1d'
      tpsa = tpsa1d if tpsa.blank?
      fpsa / tpsa
    when 'TMOTILE'
      pr = result_value_quantity_for 'PR'
      np = result_value_quantity_for 'NP'
      pr + np
    when 'TPU12H'
      uprot12h = result_value_quantity_for 'UPROT12H'
      uvol12h = result_value_quantity_for 'UVOL12H'
      uprot12h * uvol12h / 100
    when 'TPU24H'
      uprot24h = result_value_quantity_for 'UPROT24H'
      uvol24h = result_value_quantity_for 'UVOL24H'
      uprot24h * uvol24h / 100
    when 'TSPERM'
      sconc = result_value_quantity_for 'SCONC'
      svol = result_value_quantity_for 'SVOL'
      tsperm = sconc * svol
      tsperm.zero? ? '<0.1' : tsperm
    when 'VLDL'
      trig = result_value_quantity_for 'TRIG'
      trig <= 400 ? trig / 5 : nil
    when 'COSMS'
      na = result_value_quantity_for 'Na'
      bun = result_value_quantity_for 'BUN'
      glucose = result_value_quantity_for('GLU') || result_value_quantity_for('GLUC')
      na * 2 + bun / 2.8 + glucose / 18
    when 'HOMAIR'
      glucose = result_value_quantity_for('GLU') || result_value_quantity_for('GLUC')
      insulin = result_value_quantity_for('INS') || result_value_quantity_for('INSI') || result_value_quantity_for('INSG')
      glucose * insulin / 405
    when 'eGFRcr'
      age = subject_age.parts[:years]
      return if age < 18

      crtsa = result_value_quantity_for 'CRTSA'
      if patient.female?
        a = -0.241
        k = 0.7
        gender = 1.012
      elsif patient.male?
        a = -0.302
        k = 0.9
        gender = 1
      end
      crtsa_k = crtsa / k
      142 * [crtsa_k, 1].min**a * [crtsa_k, 1].max**-1.2 * 0.9938**age * gender
    when 'EGNB'
      age = subject_age.parts[:years]
      return if age < 18

      crtsa = result_value_quantity_for 'CRTSA'
      if patient.female?
        a = -0.329
        k = 0.7
        gender = 1.018
      else
        a = -0.411
        k = 0.9
        gender = 1
      end
      crtsa_k = crtsa / k
      141 * [crtsa_k, 1].min**a * [crtsa_k, 1].max**-1.209 * 0.9929**age * gender
    when 'EGFRMDRD'
      age = subject_age.parts[:years]
      return if age < 18

      crtsa = result_value_quantity_for 'CRTSA'
      gender = patient.female? ? 0.742 : 1
      175 * crtsa**-1.154 * age**-0.203 * gender
    when 'EGBL'
      age = subject_age.parts[:years]
      return if age < 18

      crtsa = result_value_quantity_for 'CRTSA'
      if patient.female?
        a = -0.329
        k = 0.7
        b_gender = 1.018 * 1.159
      else
        a = -0.411
        k = 0.9
        b_gender = 1.159
      end
      crtsa_k = crtsa / k
      141 * [crtsa_k, 1].min**a * [crtsa_k, 1].max**-1.209 * 0.9929**age * b_gender
    when 'EGFRMDRDBL'
      age = subject_age.parts[:years]
      return if age < 18

      crtsa = result_value_quantity_for 'CRTSA'
      gender = patient.female? ? 0.742 : 1
      175 * crtsa**-1.154 * age**-0.203 * gender * 1.212
    when 'uACR'
      ralb1 = result_value_quantity_for 'RALB1'
      ralb1tl = result_value_quantity_for 'RALB1TL'
      ralb1 = ralb1tl if ralb1.blank?
      cre2 = result_value_quantity_for 'CRE2'
      cre2tl = result_value_quantity_for 'CRE2TL'
      cre2 = cre2tl if cre2.blank?
      ralb1 / cre2
    end
  rescue StandardError
    nil
  end

  def result_value_codeable_concept_for(code)
    results.joins(:lab_test).find_by('lab_tests.code': code)&.value_codeable_concept
  end

  def result_value_quantity_for(code)
    results.joins(:lab_test).find_by('lab_tests.code': code)&.value_quantity&.to_d
  end

  def result_derived_value_for(code)
    results.joins(:lab_test).find_by('lab_tests.code': code)&.derived_value&.to_d
  end

  def derived_remarks_for(code)
    case code
    when 'CLDL1'
      ldl = result_derived_value_for 'CLDL1'
      return I18n.t('observations.derived_remarks.cldl1') if ldl.zero?
    when 'eGFRcr'
      egfrcr = result_derived_value_for 'eGFRcr'
      return I18n.t('observations.derived_remarks.egfrcr') if egfrcr.between?(45, 59)
    when 'PSA_R'
      tpsa = result_value_quantity_for 'TPSA'
      tpsa1d = result_value_quantity_for 'TPSA1d'
      tpsa = tpsa1d if tpsa.blank?
      psa_r = result_derived_value_for 'PSA_R'
      age = subject_age.parts[:years]
      if tpsa.between?(4, 10)
        case psa_r
        when 0..0.10
          case age
          when 50..59
            I18n.t('observations.derived_remarks.psa_r', psa_r: '≤0.10', risk: '49%')
          when 60..69
            I18n.t('observations.derived_remarks.psa_r', psa_r: '≤0.10', risk: '58%')
          when 70..Float::INFINITY
            I18n.t('observations.derived_remarks.psa_r', psa_r: '≤0.10', risk: '65%')
          end
        when 0.11..0.18
          case age
          when 50..59
            I18n.t('observations.derived_remarks.psa_r', psa_r: '0.11–0.18', risk: '27%')
          when 60..69
            I18n.t('observations.derived_remarks.psa_r', psa_r: '0.11–0.18', risk: '34%')
          when 70..Float::INFINITY
            I18n.t('observations.derived_remarks.psa_r', psa_r: '0.11–0.18', risk: '41%')
          end
        when 0.19..0.25
          case age
          when 50..59
            I18n.t('observations.derived_remarks.psa_r', psa_r: '0.19–0.25', risk: '18%')
          when 60..69
            I18n.t('observations.derived_remarks.psa_r', psa_r: '0.19–0.25', risk: '24%')
          when 70..Float::INFINITY
            I18n.t('observations.derived_remarks.psa_r', psa_r: '0.19–0.25', risk: '30%')
          end
        when 0.26..Float::INFINITY
          case age
          when 50..59
            I18n.t('observations.derived_remarks.psa_r', psa_r: '>0.25', risk: '9%')
          when 60..69
            I18n.t('observations.derived_remarks.psa_r', psa_r: '>0.25', risk: '12%')
          when 70..Float::INFINITY
            I18n.t('observations.derived_remarks.psa_r', psa_r: '>0.25', risk: '16%')
          end
        end
      end
    end
  rescue StandardError
    nil
  end
end
