# frozen_string_literal: true

class ClaimPreview < Prawn::Document
  def initialize(claim, view_context)
    @claim = claim
    @view = view_context

    super(
      info: {
        Title: 'Claim Preview',
        Author: 'MasterLab—Laboratorio Clínico Especializado',
        Subject: "Claim #{@claim.external_number}",
        Creator: 'MasterLab',
        Producer: 'MasterLab',
        CreationDate: @claim.accession.drawn_at
      },
      inline: true,
      # Letter (8.5 x 11 in) is 612 x 792
      # top_margin: 60,
      # right_margin: 36, # 0.5 in
      # bottom_margin: 71,
      # left_margin: 36, # 0.5 in
      compress: true,
      optimize_objects: true,
      print_scaling: :none
    )

    # Document defaults
    file = File.expand_path('fonts/HelveticaNeueLTStd', __dir__)
    font_families['HelveticaNeueLTStd'] = {
      normal:      { file: file + '-Roman.ttf' },
      italic:      { file: file + '-It.ttf' },
      bold:        { file: file + '-Bd.ttf' },
      bold_italic: { file: file + '-BdIt.ttf' }
    }

    file = File.expand_path('fonts/HelveticaWorld', __dir__)
    font_families['HelveticaWorld'] = {
      normal:      { file: file + '-Regular.ttf' },
      italic:      { file: file + '-Italic.ttf' },
      bold:        { file: file + '-Bold.ttf' },
      bold_italic: { file: file + '-BoldItalic.ttf' }
    }

    fallback_fonts ['HelveticaWorld']
    font 'HelveticaNeueLTStd', size: 8

    # Corporate colors
    colors = {
      black: [0, 0, 0, 100],
      white: [0, 0, 0, 0],
      gray: [0, 0, 0, 10],
      high_value: [0, 100, 100, 0],
      low_value: [100, 100, 0, 0],
      abnormal_value: [0, 100, 0, 50]
    }

    # Form defaults
    top_margin = 697
    left_margin = -25
    field_height = 12
    form_padding = 4
    form_indenting = 2

    # Cell widths
    provider_info_width = 180
    pay_to_info_width = 180
    pre_control_no_width = 382
    patient_control_number_width = 172
    type_of_bill_width = 37
    federal_tax_number_width = 72
    name_width = 210
    birthdate_width = 65
    gender_width = 22
    occurrence_code_width = 22
    occurrence_date_width = 50
    insurance_provider_width = 303
    claims_table_width = 592
    rev_cd_width = 34
    description_width = 180
    hpcs_rates_width = 108
    serv_date_width = 50
    serv_units_width = 58
    line_23_page_width = 30
    line_23_total_pages_width = 72
    line_23_page_field_width = 22
    total_charges_width = 64
    totals_width = 65
    payer_name_width = 166
    prior_payments_width = 382
    due_from_patient_width = 76
    insured_name_width = 187
    patient_relationship_width = 22
    insured_unique_id_width = 144
    code_width = 109
    main_table_rows = 23

    @claim_total_price = []

    fill_color colors[:black]
    stroke_color colors[:black]

    # Form Locator (FL) 1 - (Untitled) Provider Name, Address, and Telephone Number
    # Required. The minimum entry is the provider name, city, State, and ZIP code. The post office box number or street name and number may be included. The State may be abbreviated using standard post office abbreviations. Five or nine-digit ZIP codes are acceptable. This information is used in connection with the Medicare provider number (FL 51) to verify provider identity. Phone and/or Fax numbers are desirable.
    bounding_box([left_margin, (top_margin + field_height * 4)], width: provider_info_width, height: field_height) do
      pad(form_padding) do
        indent(form_indenting * 3) do
          text '<b>Labtec S.A.</b>', inline_format: true
        end
      end
    end
    bounding_box([left_margin, (top_margin + field_height * 3)], width: provider_info_width, height: field_height) do
      pad(form_padding) do
        indent(form_indenting * 3) do
          text 'Villa Lucre, Consultorios San Judas Tadeo #107'
        end
      end
    end
    bounding_box([left_margin, (top_margin + field_height * 2)], width: provider_info_width, height: field_height) do
      pad(form_padding) do
        indent(form_indenting * 3) do
          text 'Tel: 222-9200 ext. 1107 • Fax: 277-7832'
        end
      end
    end
    bounding_box([left_margin, (top_margin + field_height)], width: provider_info_width, height: field_height) do
      pad(form_padding) do
        indent(form_indenting * 3) do
          text 'masterlab@labtecsa.com'
        end
      end
    end
    # FL 5 - Federal Tax Number
    # Required. The format is NN-NNNNNNN.
    bounding_box([left_margin + provider_info_width + pay_to_info_width, (top_margin + field_height)], width: federal_tax_number_width, height: field_height) do
      pad_top(form_padding) do
        text '299497-1-409892 (13)', align: :center, size: 7
      end
    end
    # FL 3a - Patient Control Number
    # Required. The patient's unique alpha-numeric control number assigned by the provider to facilitate retrieval of individual financial records and posting payment may be shown if the provider assigns one and needs it for association and reference purposes.
    bounding_box([left_margin + pre_control_no_width, (top_margin + field_height * 4)], width: patient_control_number_width, height: field_height) do
      pad(form_padding) do
        text "<b>#{@claim.number}</b>", align: :center, inline_format: true
      end
    end
    # FL 3b - Medical/Health Record Number
    # Situational. The number assigned to the patient's medical/health record by the provider (not FL3a).
    bounding_box([left_margin + pre_control_no_width, (top_margin + field_height * 3)], width: patient_control_number_width, height: field_height) do
      pad(form_padding) do
        # text @claim.accession.id, align: :center, inline_format: true
      end
    end
    # FL 4 - Type of Bill
    # Required. See documentation 0132?
    bounding_box([left_margin + pre_control_no_width + patient_control_number_width, (top_margin + field_height * 3)], width: type_of_bill_width, height: field_height) do
      pad(form_padding) do
        # text "<b>0132</b>", align: :center, inline_format: true
      end
    end
    # FL 8 - Patient's Name
    # Required. The provider enters the patient's last name, first name, and, if any, middle initial, along with patient ID (if different than the subscriber/insured's ID).
    bounding_box([left_margin + 7, top_margin - field_height], width: name_width, height: field_height) do
      pad(form_padding) do
        indent(form_indenting) do
          text "<b>#{name_last_comma_first_mi(@claim.patient)}</b>", inline_format: true
        end
      end
    end
    # FL 10 - Patient's Birth Date
    # Required. The provider enters the month, day, and year of birth (MMDDCCYY) of patient. If full birth date is unknown, indicate zeros for all eight digits.
    bounding_box([left_margin, (top_margin - field_height * 3)], width: birthdate_width, height: field_height) do
      pad(form_padding) do
        indent(form_indenting) do
          text @claim.patient.birthdate.to_formatted_s(:mmddccyy)
        end
      end
    end
    # FL 11 - Patient's Sex
    # Required. The provider enters an "M" (male) or an "F" (female). The patient's sex is recorded at admission, outpatient service, or start of care.
    bounding_box([left_margin + birthdate_width, (top_margin - field_height * 3)], width: gender_width, height: field_height) do
      pad(form_padding) do
        text @claim.patient.gender, align: :center
      end
    end
    # FLs 31, 32, 33 and 34 - Occurrence Codes and Dates
    # Situational. Required when there is a condition code that applies to this claim.
    bounding_box([left_margin + occurrence_code_width, (top_margin - field_height * 5)], width: occurrence_date_width, height: field_height) do
      pad(form_padding) do
        text @claim.accession.drawn_at.to_date.to_formatted_s(:mmddyy), align: :center
      end
    end
    # FL 38 - Responsible Party Name and Address
    # Not Required. For claims that involve payers of higher priority than Medicare.
    bounding_box([left_margin, (top_margin - field_height * 7)], width: insurance_provider_width, height: field_height * 5) do
      pad_top(10) do
        pad(form_padding) do
          text @claim.insurance_provider.name, align: :center, size: 18
          text "No. #{@claim.external_number}", align: :center, size: 16
        end
      end
    end
    # Prices calculation and tables preparation
    @total_price = []
    # Panels Table
    panels_table = @claim.accession.panels.with_price.map do |panel|
      @total_price << (panel.prices.find_by(price_list_id: 1)&.amount)
      [
        '300',
        panel.name,
        panel.procedure.to_s,
        @claim.accession.drawn_at.to_date.to_formatted_s(:mmddyy),
        '1',
        (@view.number_to_currency panel.prices.find_by(price_list_id: 1).amount, unit: '', separator: ' ' if panel.prices.find_by(price_list_id: 1)).to_s
      ]
    end
    # Lab Tests Table
    @lab_tests = []
    @claim.accession.lab_tests.with_price.map do |lab_test|
      @lab_tests.push lab_test if (lab_test.panel_ids & @claim.accession.panel_ids).empty?
    end
    lab_tests_table = @lab_tests.map do |lab_test|
      @total_price << (lab_test.prices.find_by(price_list_id: 1)&.amount)
      [
        '300',
        lab_test.name,
        lab_test.procedure.to_s,
        @claim.accession.drawn_at.to_date.to_formatted_s(:mmddyy),
        '1',
        (@view.number_to_currency lab_test.prices.find_by(price_list_id: 1).amount, unit: '', separator: ' ' if lab_test.prices.find_by(price_list_id: 1)).to_s
      ]
    end
    # TOTALS
    bounding_box([left_margin + rev_cd_width + line_23_page_width, (top_margin - field_height * 35)], width: line_23_page_field_width, height: field_height) do
      pad(form_padding - 1) do
        text '<b><i>1</i></b>', align: :center, inline_format: true
      end
    end
    if (panels_table.size + lab_tests_table.size) < main_table_rows
      bounding_box([left_margin + rev_cd_width + line_23_total_pages_width, (top_margin - field_height * 35)], width: line_23_page_field_width, height: field_height) do
        pad(form_padding - 1) do
          text '<b><i>1</i></b>', align: :center, inline_format: true
        end
      end
    else
      bounding_box([left_margin + rev_cd_width + line_23_total_pages_width, (top_margin - field_height * 35)], width: line_23_page_field_width, height: field_height) do
        pad(form_padding - 1) do
          text '<b><i>2</i></b>', align: :center, inline_format: true
        end
      end
    end
    bounding_box([left_margin + rev_cd_width + description_width + hpcs_rates_width + serv_date_width + serv_units_width, (top_margin - field_height * 35)], width: totals_width, height: field_height) do
      @claim_total_price << @total_price.sum
      pad(form_padding - 1) do
        text "<b><i>#{@view.number_to_currency @total_price.sum, unit: '', separator: ' '}</i></b>", align: :right, inline_format: true, size: 9
      end
    end
    # FL 50A, B, and C - Payer Identification
    bounding_box([left_margin, (top_margin - field_height * 37)], width: payer_name_width, height: field_height) do
      pad(form_padding) do
        indent(form_indenting) do
          text 'PCABP', align: :left
        end
      end
    end
    # FL 55A, B, and C - Estimated Amount Due From Patient
    bounding_box([left_margin + prior_payments_width, (top_margin - field_height * 37)], width: due_from_patient_width, height: field_height) do
      pad(form_padding) do
        text (@view.number_to_currency @total_price.sum, unit: '', separator: ' ').to_s, align: :right
      end
    end
    # FLs 58A, B, and C - Insured's Name
    # Required. On the same lettered line (A, B or C) that corresponds to the line on which Medicare payer information is shown in FLs 50-54, the provider must enter the patient's name as shown on the HI card or other Medicare notice. All additional entries across line A (FLs 59-66) pertain to the person named in Item 58A. The instructions that follow explain when to complete these items.
    bounding_box([left_margin, (top_margin - field_height * 41)], width: insured_name_width, height: field_height) do
      pad(form_padding) do
        indent(form_indenting) do
          text name_last_comma_first_mi(@claim.insured_name)
        end
      end
    end
    # FLs 60A, B, and C - Insured's Unique ID (Certificate/Social Security Number/HI Claim/Identification Number (HICN))
    # Required. On the same lettered line (A, B, or C) that corresponds to the line on which Medicare payer information is shown in FLs 50-54, the provider enters the patient's HICN, i.e., if Medicare is the primary payer, it enters this information in FL 60A. It shows the number as it appears on the patient's HI Card, Certificate of Award, Medicare Summary Notice, or as reported by the Social Security Office.
    # If the provider is reporting any other insurance coverage higher in priority than Medicare (e.g., EGHP for the patient or the patient's spouse or during the first year of ESRD entitlement), it shows the involved claim number for that coverage on the appropriate line.
    bounding_box([left_margin + insured_name_width + patient_relationship_width, (top_margin - field_height * 41)], width: insured_unique_id_width, height: field_height) do
      pad(form_padding) do
        text @claim.insured_policy_number, align: :center
      end
    end
    # FL 74 - Principal Procedure Code and Date Situational. Required on inpatient claims when a procedure was performed. Not used on outpatient claims.
    # FL 74A - 74E - Other Procedure Codes and Dates Situational. Required on inpatient claims when additional procedures must be reported. Not used on outpatient claims.
    diag_codes = (@claim.accession.icd9.split(',').map(&:strip) if @claim.accession.icd9.present?) || ['pend.']
    diag_codes.each_with_index do |diag_code, i|
      bounding_box([left_margin + code_width * i, (top_margin - field_height * 52)], width: code_width, height: field_height) do
        pad(form_padding) do
          indent(form_indenting) do
            text diag_code.upcase
          end
        end
      end
    end
    # FL 43 - Revenue Description
    # Not Required. The provider enters a narrative description or standard abbreviation for each revenue code shown in FL 42 on the adjacent line in FL 43. The information assists clerical bill review. Descriptions or abbreviations correspond to the revenue codes. "Other" code categories are locally defined and individually described on each bill. The investigational device exemption (IDE) or procedure identifies a specific device used only for billing under the specific revenue code 0624. The IDE will appear on the paper format of Form CMS-1450 as follows: FDA IDE # A123456 (17 spaces). HHAs identify the specific piece of DME or non-routine supplies for which they are billing in this area on the line adjacent to the related revenue code. This description must be shown in HCPCS coding. (Also see FL 80, Remarks.)
    # FL 44 - HCPCS/Rates/HIPPS Rate Codes
    # Required. When coding HCPCS for outpatient services, the provider enters the HCPCS code describing the procedure here. On inpatient hospital bills the accommodation rate is shown here.
    # FL 45 - Service Date
    # Required Outpatient. Effective June 5, 2000, CMHCs and hospitals (with the exception of CAHs, Indian Health Service hospitals and hospitals located in American Samoa, Guam and Saipan) report line item dates of service on all bills containing revenue codes, procedure codes or drug codes. This includes claims where the "from" and "through" dates are equal. This change is due to a HIPAA requirement.
    # Inpatient claims for skilled nursing facilities and swing bed providers enter the assessment reference date (ARD) here where applicable.
    # There must be a single line item date of service (LIDOS) for every iteration of every revenue code on all outpatient bills (TOBs 013X, 014X, 023X, 024X, 032X, 033X, 034X, 071X, 072X, 073X, 074X, 075X, 076X, 081X, 082X, 083X, and 085X and on inpatient Part B bills (TOBs 012x and 022x). If a particular service is rendered 5 times during the billing period, the revenue code and HCPCS code must be entered 5 times, once for each service date. Assessment Date - used for billing SNF PPS (Bill Type 021X).
    # FL 47 - Total Charges - Not Applicable for Electronic Billers
    # Required. This is the FL in which the provider sums the total charges for the billing period for each revenue code (FL 42); or, if the services require, in addition to the revenue center code, a HCPCS procedure code, where the provider sums the total charges for the billing period for each HCPCS code. The last revenue code entered in FL 42 is "0001" which represents the grand total of all charges billed. The amount for this code, as for all others is entered in FL 47. Each line for FL 47 allows up to nine numeric digits (0000000.00). The CMS policy is for providers to bill Medicare on the same basis that they bill other payers. This policy provides consistency of bill data with the cost report so that bill data may be used to substantiate the cost report. Medicare and non-Medicare charges for the same department must be reported consistently on the cost report. This means that the professional component is included on, or excluded from, the cost report for Medicare and non-Medicare charges. Where billing for the professional components is not consistent for all payers, i.e., where some payers require net billing and others require gross, the provider must adjust either net charges up to gross or gross charges down to net for cost report preparation. In such cases, it must adjust its provider statistical and reimbursement (PS&R) reports that it derives from the bill. Laboratory tests (revenue codes 0300-0319) are billed as net for outpatient or nonpatient bills because payment is based on the lower of charges for the hospital component or the fee schedule. The FI determines, in consultation with the provider, whether the provider must bill net or gross for each revenue center other than laboratory. Where "gross" billing is used, the FI adjusts interim payment rates to exclude payment for hospital-based physician services. The physician component must be billed to the carrier to obtain payment. All revenue codes requiring HCPCS codes and paid under a fee schedule are billed as net.
    bounding_box([left_margin, (top_margin - field_height * 13)], width: claims_table_width, height: field_height * main_table_rows) do
      # Output Panels Table
      if panels_table.present?
        table panels_table, column_widths: {
          0 => rev_cd_width,
          1 => description_width,
          2 => hpcs_rates_width,
          3 => serv_date_width,
          4 => serv_units_width,
          5 => total_charges_width
        },
                            cell_style: {
                              size: 8,
                              height: field_height,
                              padding: [form_padding - 2.5, form_padding - 2.5],
                              inline_format: true
                            } do |t|
          t.cells.borders = []
          t.column(0).style align: :center
          t.column(1).style align: :left
          t.column(2).style align: :center
          t.column(3).style align: :center
          t.column(4).style align: :center
          t.column(5).style align: :right
        end
      end
      # Output Lab Tests Table
      @background_form = true
      if lab_tests_table.present?
        table lab_tests_table, column_widths: { 0 => rev_cd_width,
                                                1 => description_width,
                                                2 => hpcs_rates_width,
                                                3 => serv_date_width,
                                                4 => serv_units_width,
                                                5 => total_charges_width },
                               cell_style: { size: 8, height: field_height, padding: [form_padding - 2.5, form_padding - 2.5], inline_format: true } do |t|
          t.before_rendering_page do
            unless @background_form
              # Form Locator (FL) 1 - (Untitled) Provider Name, Address, and Telephone Number
              # Required. The minimum entry is the provider name, city, State, and ZIP code. The post office box number or street name and number may be included. The State may be abbreviated using standard post office abbreviations. Five or nine-digit ZIP codes are acceptable. This information is used in connection with the Medicare provider number (FL 51) to verify provider identity. Phone and/or Fax numbers are desirable.
              bounding_box([0, field_height * (main_table_rows + 17)], width: provider_info_width, height: field_height) do
                pad(form_padding) do
                  indent(form_indenting * 3) do
                    text '<b>Labtec S.A.</b>', inline_format: true
                  end
                end
              end
              bounding_box([0, field_height * (main_table_rows + 16)], width: provider_info_width, height: field_height) do
                pad(form_padding) do
                  indent(form_indenting * 3) do
                    text 'Villa Lucre, Consultorios San Judas Tadeo #107'
                  end
                end
              end
              bounding_box([0, field_height * (main_table_rows + 15)], width: provider_info_width, height: field_height) do
                pad(form_padding) do
                  indent(form_indenting * 3) do
                    text 'Tel: 222-9200 ext. 1107 • Fax: 277-7832'
                  end
                end
              end
              bounding_box([0, field_height * (main_table_rows + 14)], width: provider_info_width, height: field_height) do
                pad(form_padding) do
                  indent(form_indenting * 3) do
                    text 'masterlab@labtecsa.com'
                  end
                end
              end
              # FL 5 - Federal Tax Number
              # Required. The format is NN-NNNNNNN.
              bounding_box([provider_info_width + pay_to_info_width, field_height * (main_table_rows + 14)], width: federal_tax_number_width, height: field_height) do
                pad_top(form_padding) do
                  text '299497-1-409892 (13)', align: :center, size: 7
                end
              end
              # FL 3a - Patient Control Number
              # Required. The patient's unique alpha-numeric control number assigned by the provider to facilitate retrieval of individual financial records and posting payment may be shown if the provider assigns one and needs it for association and reference purposes.
              bounding_box([pre_control_no_width, field_height * (main_table_rows + 17)], width: patient_control_number_width, height: field_height) do
                pad(form_padding) do
                  text "<b>#{@claim.number}</b>", align: :center, inline_format: true
                end
              end
              # FL 8 - Patient's Name
              # Required. The provider enters the patient's last name, first name, and, if any, middle initial, along with patient ID (if different than the subscriber/insured's ID).
              bounding_box([7, field_height * (main_table_rows + 12)], width: name_width, height: field_height) do
                pad(form_padding) do
                  indent(form_indenting) do
                    text "<b>#{name_last_comma_first_mi(@claim.patient)}</b>", inline_format: true
                  end
                end
              end
              # FL 10 - Patient's Birth Date
              # Required. The provider enters the month, day, and year of birth (MMDDCCYY) of patient. If full birth date is unknown, indicate zeros for all eight digits.
              bounding_box([0, field_height * (main_table_rows + 10)], width: birthdate_width, height: field_height) do
                pad(form_padding) do
                  indent(form_indenting) do
                    text @claim.patient.birthdate.to_formatted_s(:mmddccyy)
                  end
                end
              end
              # FL 11 - Patient's Sex
              # Required. The provider enters an "M" (male) or an "F" (female). The patient's sex is recorded at admission, outpatient service, or start of care.
              bounding_box([birthdate_width, field_height * (main_table_rows + 10)], width: gender_width, height: field_height) do
                pad(form_padding) do
                  text @claim.patient.gender, align: :center
                end
              end
              # FLs 31, 32, 33 and 34 - Occurrence Codes and Dates
              # Situational. Required when there is a condition code that applies to this claim.
              bounding_box([occurrence_code_width, field_height * (main_table_rows + 8)], width: occurrence_date_width, height: field_height) do
                pad(form_padding) do
                  text @claim.accession.drawn_at.to_date.to_formatted_s(:mmddyy), align: :center
                end
              end
              # FL 38 - Responsible Party Name and Address
              # Not Required. For claims that involve payers of higher priority than Medicare.
              bounding_box([0, field_height * (main_table_rows + 6)], width: insurance_provider_width, height: field_height * 5) do
                pad_top(10) do
                  pad(form_padding) do
                    text @claim.insurance_provider.name, align: :center, size: 18
                    text "No. #{@claim.external_number}", align: :center, size: 16
                  end
                end
              end
              # TOTALS
              bounding_box([rev_cd_width + line_23_page_width, field_height], width: line_23_page_field_width, height: field_height) do
                pad(form_padding - 1) do
                  text '<b><i>2</i></b>', align: :center, inline_format: true
                end
              end
              bounding_box([rev_cd_width + line_23_total_pages_width, field_height], width: line_23_page_field_width, height: field_height) do
                pad(form_padding - 1) do
                  text '<b><i>2</i></b>', align: :center, inline_format: true
                end
              end
              bounding_box([rev_cd_width + description_width + hpcs_rates_width + serv_date_width + serv_units_width, field_height], width: totals_width, height: field_height) do
                pad(form_padding - 1) do
                  text "<b><i>#{@view.number_to_currency @total_price.sum, unit: '', separator: ' '}</i></b>", align: :right, inline_format: true, size: 9
                end
              end
              # FL 50A, B, and C - Payer Identification
              bounding_box([0, -field_height], width: payer_name_width, height: field_height) do
                pad(form_padding) do
                  indent(form_indenting) do
                    text 'PCABP', align: :left
                  end
                end
              end
              # FL 55A, B, and C - Estimated Amount Due From Patient
              bounding_box([prior_payments_width, -field_height], width: due_from_patient_width, height: field_height) do
                pad(form_padding) do
                  text (@view.number_to_currency @total_price.sum, unit: '', separator: ' ').to_s, align: :right
                end
              end
              # FLs 58A, B, and C - Insured's Name
              # Required. On the same lettered line (A, B or C) that corresponds to the line on which Medicare payer information is shown in FLs 50-54, the provider must enter the patient's name as shown on the HI card or other Medicare notice. All additional entries across line A (FLs 59-66) pertain to the person named in Item 58A. The instructions that follow explain when to complete these items.
              bounding_box([0, -(field_height * 5)], width: insured_name_width, height: field_height) do
                pad(form_padding) do
                  indent(form_indenting) do
                    text name_last_comma_first_mi(@claim.insured_name)
                  end
                end
              end
              # FLs 60A, B, and C - Insured's Unique ID (Certificate/Social Security Number/HI Claim/Identification Number (HICN))
              # Required. On the same lettered line (A, B, or C) that corresponds to the line on which Medicare payer information is shown in FLs 50-54, the provider enters the patient's HICN, i.e., if Medicare is the primary payer, it enters this information in FL 60A. It shows the number as it appears on the patient's HI Card, Certificate of Award, Medicare Summary Notice, or as reported by the Social Security Office.
              # If the provider is reporting any other insurance coverage higher in priority than Medicare (e.g., EGHP for the patient or the patient's spouse or during the first year of ESRD entitlement), it shows the involved claim number for that coverage on the appropriate line.
              bounding_box([insured_name_width + patient_relationship_width, -(field_height * 5)], width: insured_unique_id_width, height: field_height) do
                pad(form_padding) do
                  text @claim.insured_policy_number, align: :center
                end
              end
              # FL 74 - Principal Procedure Code and Date Situational. Required on inpatient claims when a procedure was performed. Not used on outpatient claims.
              # FL 74A - 74E - Other Procedure Codes and Dates Situational. Required on inpatient claims when additional procedures must be reported. Not used on outpatient claims.
              diag_codes = (@claim.accession.icd9.split(',').map(&:strip) if claim.accession.icd9.present?) || ['pend.']
              diag_codes.each_with_index do |diag_code, i|
                bounding_box([code_width * i, -(field_height * 16)], width: code_width, height: field_height) do
                  pad(form_padding) do
                    indent(form_indenting) do
                      text diag_code.upcase
                    end
                  end
                end
              end
            end
            @background_form = false
          end
          t.cells.borders = []
          t.column(0).style align: :center
          t.column(1).style align: :left
          t.column(2).style align: :center
          t.column(3).style align: :center
          t.column(4).style align: :center
          t.column(5).style align: :right
        end
      end
    end
  end

  private

  def method_missing(*args, &block)
    @view.send(*args, &block)
  end
end
