# frozen_string_literal: true

require_relative 'images/logos/master_lab'
require 'barby'
require 'barby/barcode/data_matrix'
require 'barby/outputter/prawn_outputter'

class LabReport < Prawn::Document
  BARCODE_XDIM = 1.5
  COLUMN_0_WIDTH = 140
  COLUMN_1_WIDTH = 80
  COLUMN_2_WIDTH = 88
  COLUMN_3_WIDTH = 40
  COLUMN_RANGE_WIDTH = 192
  DEMOGRAPHICS_WIDTH1 = 45
  DEMOGRAPHICS_WIDTH2 = 155
  DEMOGRAPHICS_WIDTH4 = 80
  DEMOGRAPHICS_WIDTH5 = 80
  DEMOGRAPHICS_WIDTH6 = 150
  ENVELOPE_ADJUSTMENT_HEIGHT = 47
  FLASH_TAG_WIDTH = 80
  HALF_INCH = 36
  HEADING_INDENT = 20
  HEADING_PADDING = 5.5
  HEAVY_RULE_WIDTH = 2
  LIGHT_RULE_WIDTH = 0.5
  LINE_PADDING = 2
  LOGO_HEIGHT = 50
  LOGO_WIDTH = 150
  NORMAL_RULE_WIDTH = 1
  NOTES_INDENT = 25
  NOTES_PADDING = 7
  PADDING = 5
  ROW_VERTICAL_PADDING = 1
  SIGNATURE_BLOCK_SHIM = 75

  DEMOGRAPHICS_STOP1 = DEMOGRAPHICS_WIDTH1
  DEMOGRAPHICS_STOP2 = DEMOGRAPHICS_STOP1 + DEMOGRAPHICS_WIDTH2
  FOOTER_MARGIN_BOTTOM = HALF_INCH
  TITLE_ROW_STOP1 = COLUMN_0_WIDTH
  TITLE_ROW_STOP2 = TITLE_ROW_STOP1 + COLUMN_1_WIDTH
  TITLE_ROW_STOP3 = TITLE_ROW_STOP2 + COLUMN_2_WIDTH
  TITLE_ROW_STOP4 = TITLE_ROW_STOP3 + COLUMN_3_WIDTH

  ##
  # Folding marks and window (do not print)
  # ONE_INCH = HALF_INCH * 2
  # PRINT_SAFETY_AREA = 17
  # WINDOW_HEIGHT = 36 * 2.25
  # WINDOW_WIDTH = 36 * 9

  def initialize(patient, accession, results, signature, view_context)
    @patient = patient
    @accession = accession
    @results = results
    @signature = signature
    @view = view_context

    super(
      info: {
        Title: 'Reporte de Resultados',
        Author: 'MasterLab',
        Subject: "Solicitud #{@accession.id}",
        Creator: 'MasterLab',
        Producer: 'MasterLab',
        CreationDate: @accession.drawn_at,
        ModDate: @accession.reported_at,
        Keywords: "prueba laboratorio reporte resultado #{@accession.id}"
      },
      inline: true,
      # Letter (8.5 x 11 in) is 612 x 792
      top_margin: 60,
      # right_margin: 36, # 0.5 in
      bottom_margin: 71,
      # left_margin: 36, # 0.5 in
      compress: true,
      optimize_objects: true,
      enable_pdfa_1b: signature,
      print_scaling: :none
    )

    ##
    # Document fonts
    file = File.expand_path('fonts/MyriadPro', __dir__)
    font_families['MyriadPro'] = {
      normal: { file: "#{file}-Regular.ttf" },
      italic: { file: "#{file}-SemiCnIt.ttf" },
      bold: { file: "#{file}-Semibold.ttf" },
      bold_italic: { file: "#{file}-BoldSemiCnIt.ttf" }
    }

    file = File.expand_path('fonts/OCR-B', __dir__)
    font_families['OCRB'] = {
      normal: { file: "#{file}.ttf" }
    }

    file = File.expand_path('fonts/HelveticaWorld', __dir__)
    font_families['HelveticaWorld'] = {
      normal: { file: "#{file}-Regular.ttf" },
      italic: { file: "#{file}-Italic.ttf" },
      bold: { file: "#{file}-Bold.ttf" },
      bold_italic: { file: "#{file}-BoldItalic.ttf" }
    }

    font 'HelveticaWorld', size: 8

    ##
    # Colors
    fill_color colors_black
    stroke_color colors_black
    flag_color = {
      high_value: colors_red,
      low_value: colors_blue,
      abnormal_value: colors_purple
    }

    ##
    # Variables
    top_margin = page.margins[:top]
    bottom_margin = page.margins[:bottom]
    page_top = bounds.top + top_margin
    page_bottom = bounds.bottom - bottom_margin
    colors_light_gray = @signature ? 'E6E6E6' : [0, 0, 0, 10]
    column_0_width = column_description_range_width
    column_1_width = column_gender_range_width
    column_2_width = column_left_range_width
    column_3_width = column_range_symbol_width
    column_4_width = column_right_range_width
    page_number_height = font_size - 0.25
    footer_height = line_height * 3 + PADDING
    signature_spacing = line_height * 3
    signature_line = 180
    signature_block_height = signature_spacing + line_height * 3 + PADDING
    page.margins[:top] = top_margin + LOGO_HEIGHT + header_height

    ##
    # Folding marks and window (do not print)
    # fold = page.dimensions[3] / 3
    # left_margin = page.margins[:left]
    # page_left = bounds.left - left_margin
    # horizontal_line page_left, page_left + PRINT_SAFETY_AREA, at: page_top - fold
    # horizontal_line page_left, page_left + PRINT_SAFETY_AREA, at: page_top - 2 * fold
    # rounded_rectangle [page_left + HALF_INCH / 2, page_top - fold + ONE_INCH + WINDOW_HEIGHT], WINDOW_WIDTH, WINDOW_HEIGHT, 10

    ##
    # Header
    repeat :all do
      ##
      # Flash tag top
      bounding_box([bounds.right - FLASH_TAG_WIDTH, page_top - HALF_INCH - line_height], width: FLASH_TAG_WIDTH, height: line_height) do
        text t("results.index.#{@accession.status}"), align: :right, color: colors_red
      end
      bounding_box([bounds.right - barcode_width, bounds.top], width: barcode_width, height: barcode_height) do
        barcode
      end
      formatted_text_box(
        [
          { text: @accession.id.to_s, font: 'OCRB', size: 5, overflow: :shrink_to_fit }
        ],
        at: [bounds.right - barcode_width, bounds.top - barcode_height - LINE_PADDING],
        width: barcode_width,
        height: 5.5,
        align: :center
      )

      letterhead
      move_down ENVELOPE_ADJUSTMENT_HEIGHT
      patient_demographics
      report_header
    end

    ##
    # Begin report

    move_up LINE_PADDING

    ##
    # Results table
    @results.each do |department, test_results|
      next unless test_results.map(&:performed?).any?

      department_title = make_cell content: department.name, font_style: :bold, padding: [PADDING, 0, LINE_PADDING, 0]
      if @accession.reported_at
        run_by = make_cell content: [t('results.index.run_by'), @accession.reporter.initials, t('results.index.on_date'), l(@accession.reported_at, format: :long)].join(' ').to_s, font_style: :italic, size: 7, colspan: 2, align: :right, padding: [PADDING, PADDING, LINE_PADDING, 0]
        data = [[department_title, '', '', run_by]]
      else
        data = [[department_title, '', '', '', '']]
      end
      test_results.each do |result|
        next if result.not_performed?

        if result.normal?
          cell_col0 = make_cell content: result.lab_test_name, inline_format: true, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
          cell_col1 = make_cell content: format_value(result).gsub(/</, '&lt; ').gsub(/&lt; i/, '<i').gsub(/&lt; s/, '<s').gsub(%r{&lt; /}, '</'), inline_format: true, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
        else
          cell_col0 = make_cell content: result.lab_test_name, background_color: colors_highlight_gray, inline_format: true, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
          cell_col1 = make_cell content: format_value(result).gsub(/</, '&lt; ').gsub(/&lt; i/, '<i').gsub(/&lt; s/, '<s').gsub(%r{&lt; /}, '</'), background_color: colors_highlight_gray, inline_format: true, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
        end
        cell_col2 = make_cell content: display_format_units(result), padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
        cell_col3 = make_cell content: flag_name(result), font_style: :bold, text_color: flag_color[flag_color(result).to_sym], padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
        ##
        # Ranges sub-table
        pdf_ranges_table = make_table(ranges_table(ranges_for_table(result), display_gender: @patient.unknown?), cell_style: { padding: [0, 0.4], borders: [] }) do
          column(0).align = :right
          column(1).align = :right
          column(2).align = :right
          column(3).align = :center
          column(4).align = :left
          column(0).width = column_0_width
          column(1).width = column_1_width
          column(2).width = column_2_width
          column(3).width = column_3_width
          column(4).width = column_4_width
        end
        cell_col4 = make_cell content: pdf_ranges_table, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, 0]

        if result.lab_test_remarks.present?
          remarks = make_cell content: result.lab_test_remarks.to_s, inline_format: true, colspan: 5, size: 7, padding: [0, PADDING, ROW_VERTICAL_PADDING, PADDING * 2]
          derived_remarks = make_cell content: result.derived_remarks.to_s, inline_format: true, colspan: 5, size: 7, padding: [0, PADDING, ROW_VERTICAL_PADDING, PADDING * 2]

          data_remarks = [[cell_col0, cell_col1, cell_col2, cell_col3, cell_col4]]
          data_remarks << [remarks]
          data_remarks << [derived_remarks]

          data_remarks_table = make_table(data_remarks, cell_style: { borders: [] }) do
            column(0).width = COLUMN_0_WIDTH
            column(1).width = COLUMN_1_WIDTH
            column(2).width = COLUMN_2_WIDTH
            column(3).width = COLUMN_3_WIDTH
            column(4).width = COLUMN_RANGE_WIDTH
            column(1).align = :right
            column(3).align = :center
          end

          data_remarks_cell = make_cell content: data_remarks_table, colspan: 5
          data << [data_remarks_cell]
        else
          data << [cell_col0, cell_col1, cell_col2, cell_col3, cell_col4]
        end
      end

      # Department table
      table(data, header: true) do
        column(0).width = COLUMN_0_WIDTH
        column(1).width = COLUMN_1_WIDTH
        column(2).width = COLUMN_2_WIDTH
        column(3).width = COLUMN_3_WIDTH
        column(4).width = COLUMN_RANGE_WIDTH
        row(0).borders = []
        row(1..-1).column(1).align = :right
        row(1..-1).column(3).align = :center
        row(1..-1).border_bottom_color = colors_light_gray
        row(1..-1).borders = [:bottom]
        row(1..-1).border_width = LIGHT_RULE_WIDTH
      end

      next if @accession.notes.find_by(department_id: department).try(:content).blank?

      pad_top NOTES_PADDING do
        bounding_box([NOTES_INDENT, cursor + LINE_PADDING], width: bounds.width - NOTES_INDENT) do
          text t('results.index.notes'), color: colors_purple, style: :bold
          text @accession.notes.find_by(department_id: department).content, inline_format: true

          stroke_color colors_purple
          line_width(HEAVY_RULE_WIDTH)
          stroke do
            vertical_line bounds.top + LINE_PADDING, bounds.bottom + LINE_PADDING, at: bounds.left - PADDING
          end
          line_width(NORMAL_RULE_WIDTH)
          stroke_color colors_black
        end
      end
    end

    ##
    # End of report
    stroke_horizontal_rule

    ##
    # Signature block
    if cursor > bounds.bottom + signature_block_height
      move_down signature_spacing
      if @accession.reported_at
        bounding_box([bounds.left, cursor], width: bounds.width / 2, height: line_height) do
          pad_top LINE_PADDING do
            text t('results.index.reviewed_by'), align: :right
          end
        end
        bounding_box([bounds.width / 2 + LINE_PADDING, cursor], width: signature_line, height: 2 * line_height + PADDING) do
          line_width(LIGHT_RULE_WIDTH)
          stroke_horizontal_rule
          line_width(NORMAL_RULE_WIDTH)
          signature_image
          pad_top PADDING do
            text current_user_name, align: :center
          end
          text registration_number, align: :center
        end
      end
    elsif @accession.reported_at
      bounding_box([bounds.left + SIGNATURE_BLOCK_SHIM, page_bottom + FOOTER_MARGIN_BOTTOM + footer_height * 2 / 3 + LIGHT_RULE_WIDTH], width: COLUMN_0_WIDTH, height: line_height) do
        pad_top LINE_PADDING do
          text t('results.index.reviewed_by'), align: :right
        end
      end
      bounding_box([SIGNATURE_BLOCK_SHIM + COLUMN_0_WIDTH + LINE_PADDING, cursor - NORMAL_RULE_WIDTH], width: signature_line, height: line_height + PADDING) do
        line_width(LIGHT_RULE_WIDTH)
        stroke_horizontal_rule
        line_width(NORMAL_RULE_WIDTH)
        signature_image
        pad_top PADDING do
          text current_user_name + registration_number(inline: true), align: :center
        end
      end
    end

    ##
    # Footer
    repeat :all do
      bounding_box([bounds.left, page_bottom + footer_height + FOOTER_MARGIN_BOTTOM], width: bounds.width, height: footer_height) do
        stroke_horizontal_rule
        bounding_box([bounds.left, bounds.top], width: bounds.width / 2, height: footer_height) do
          pad_top PADDING do
            text %(#{t('results.index.reported_at')} #{if @accession.reported_at
                                                         l(@accession.reported_at, format: :long)
                                                       else
                                                         t("results.index.#{@accession.status}")
                                                       end})
            text "#{t('results.index.printed_at')} #{l(Time.current, format: :long)}"
          end
        end
        bounding_box([bounds.left, bounds.top], width: bounds.width, height: footer_height) do
          pad_top PADDING do
            text "#{t('results.index.accession')} #{@accession.id}", align: :right
            text "#{t('results.index.results_of')} #{full_name(@patient)}", align: :right
            text t("results.index.#{@accession.status}"), align: :right, color: colors_red
          end
        end
      end
    end

    ##
    # Page number
    number_pages "#{t('results.index.page')} <page> #{t('results.index.of')} <total>", at: [bounds.left, page_bottom + FOOTER_MARGIN_BOTTOM + page_number_height]
  end

  private

  def barcode
    barcode = Barby::DataMatrix.new(@accession.id.to_s)
    barcode.annotate_pdf(self, xdim: BARCODE_XDIM)
  end

  def barcode_height
    barcode_width + HEADING_PADDING
  end

  def barcode_width
    length = @accession.id.to_s.length
    (length + 7) * BARCODE_XDIM
  end

  def colors_black
    @signature ? '000000' : [0, 0, 0, 100]
  end

  def colors_gray
    @signature ? '404040' : [0, 0, 0, 75]
  end

  def colors_highlight_gray
    @signature ? 'D9D9D9' : [0, 0, 0, 15]
  end

  def colors_purple
    @signature ? '800080' : [0, 100, 0, 50]
  end

  def colors_red
    @signature ? 'FF0000' : [0, 100, 100, 0]
  end

  def colors_blue
    @signature ? '0000FF' : [100, 100, 0, 0]
  end

  def column_range_symbol_width
    font_size - 2
  end

  def column_description_range_width
    @patient.unknown? ? 93 : 105
  end

  def column_gender_range_width
    @patient.unknown? ? 12 : 0
  end

  def column_left_range_width
    (COLUMN_RANGE_WIDTH - column_range_title_width - column_range_symbol_width) / 2
  end

  def column_range_title_width
    column_gender_range_width + column_description_range_width
  end

  def column_right_range_width
    column_left_range_width
  end

  def demographics_stop3
    DEMOGRAPHICS_STOP2 + demographics_width3
  end

  def demographics_stop4
    demographics_stop3 + DEMOGRAPHICS_WIDTH4
  end

  def demographics_stop5
    demographics_stop4 + DEMOGRAPHICS_WIDTH5
  end

  def demographics_width3
    @patient.animal_type ? 40 : 30
  end

  def display_format_units(result)
    format_units(result) if display_units(result)
  end

  def header_height
    ENVELOPE_ADJUSTMENT_HEIGHT + patient_demographics_height + title_row_height
  end

  def letterhead
    translate(bounds.left, bounds.top - LOGO_HEIGHT) do
      logo_master_lab(rgb: @signature)
    end

    bounding_box([bounds.left + LOGO_WIDTH, bounds.top], width: bounds.width - LOGO_WIDTH, height: LOGO_HEIGHT) do
      pad_top HEADING_PADDING do
        indent HEADING_INDENT do
          font('MyriadPro') do
            text 'MasterLab—Laboratorio Clínico Especializado', size: 11, style: :bold
            text 'Villa Lucre • Consultorios Médicos San Judas Tadeo • Local 107', size: 9, color: colors_gray
            text 'Tel.: 222-9200 ext. 1107 • Fax: 277-7832 • Móvil: 6869-5210', size: 9, color: colors_gray
            text 'Email: masterlab@labtecsa.com • Director: Lcdo. Erick Chu, TM, MSc', size: 9, color: colors_gray
          end
        end
      end
    end
  end

  def line_height
    font_size + LINE_PADDING
  end

  def patient_demographics
    bounding_box([bounds.left, cursor], width: bounds.width, height: patient_demographics_height) do
      bounding_box([bounds.left, bounds.top], width: DEMOGRAPHICS_WIDTH1, height: row_height) do
        indent PADDING do
          text t('results.index.full_name'), style: :bold
        end
      end
      bounding_box([bounds.left, bounds.top - row_height], width: DEMOGRAPHICS_WIDTH1, height: row_height) do
        indent PADDING do
          text t("results.index.#{@patient.identifier_type}") if @patient.identifier_type
        end
      end
      if @accession.doctor
        bounding_box([bounds.left, bounds.top - 2 * row_height], width: DEMOGRAPHICS_WIDTH1, height: row_height) do
          indent PADDING do
            text t('results.index.doctor')
          end
        end
      else
        bounding_box([bounds.left, bounds.top - 2 * row_height], width: DEMOGRAPHICS_WIDTH1 + DEMOGRAPHICS_WIDTH2, height: row_height) do
          indent PADDING do
            text t('results.index.outpatient')
          end
        end
      end
      text_box full_name(@patient), at: [DEMOGRAPHICS_STOP1, bounds.top],
                                    width: DEMOGRAPHICS_WIDTH2 +
                                           demographics_width3 +
                                           DEMOGRAPHICS_WIDTH4,
                                    height: row_height,
                                    overflow: :shrink_to_fit,
                                    style: :bold
      bounding_box([DEMOGRAPHICS_STOP1, bounds.top - row_height], width: DEMOGRAPHICS_WIDTH2, height: row_height) do
        text @patient.identifier
      end
      bounding_box([DEMOGRAPHICS_STOP1, bounds.top - 2 * row_height], width: DEMOGRAPHICS_WIDTH2, height: row_height) do
        text @accession.doctor_name if @accession.doctor
      end

      ########################

      if @patient.animal_type
        bounding_box([DEMOGRAPHICS_STOP2, bounds.top], width: demographics_width3, height: row_height) do
          text t('results.index.type'), style: :bold
        end
      end
      bounding_box([DEMOGRAPHICS_STOP2, bounds.top - row_height], width: demographics_width3, height: row_height) do
        text t('results.index.age')
      end
      bounding_box([DEMOGRAPHICS_STOP2, bounds.top - 2 * row_height], width: demographics_width3, height: row_height) do
        text t('results.index.gender')
      end
      if @patient.animal_type
        bounding_box([demographics_stop3, bounds.top], width: DEMOGRAPHICS_WIDTH4, height: row_height) do
          text animal_species_name(@patient.animal_type), style: :bold
        end
      end
      bounding_box([demographics_stop3, bounds.top - row_height], width: DEMOGRAPHICS_WIDTH4, height: row_height) do
        text display_pediatric_age(@accession.subject_pediatric_age)
      end
      bounding_box([demographics_stop3, bounds.top - 2 * row_height], width: DEMOGRAPHICS_WIDTH4, height: row_height) do
        text gender(@patient.gender)
      end

      ########################

      bounding_box([demographics_stop4, bounds.top], width: DEMOGRAPHICS_WIDTH5, height: row_height) do
        text t('results.index.accession'), style: :bold
      end
      bounding_box([demographics_stop4, bounds.top - row_height], width: DEMOGRAPHICS_WIDTH5, height: row_height) do
        text t('results.index.drawn_at')
      end
      bounding_box([demographics_stop4, bounds.top - 2 * row_height], width: DEMOGRAPHICS_WIDTH5, height: row_height) do
        text t('results.index.received_at')
      end
      bounding_box([demographics_stop5, bounds.top], width: DEMOGRAPHICS_WIDTH6, height: row_height) do
        text @accession.id.to_s, style: :bold
      end
      bounding_box([demographics_stop5, bounds.top - row_height], width: DEMOGRAPHICS_WIDTH6, height: row_height) do
        text l(@accession.drawn_at, format: :long)
      end
      bounding_box([demographics_stop5, bounds.top - 2 * row_height], width: DEMOGRAPHICS_WIDTH6, height: row_height) do
        text l(@accession.received_at, format: :long)
      end
    end
  end

  def patient_demographics_height
    row_height * 3
  end

  def report_header
    line_width(HEAVY_RULE_WIDTH)
    stroke_line(bounds.left, cursor, bounds.width, cursor)

    bounding_box([bounds.left, cursor], width: bounds.width, height: title_row_height) do
      bounding_box([bounds.left, bounds.top], width: COLUMN_0_WIDTH, height: title_row_height) do
        pad_top PADDING do
          indent PADDING do
            text t('results.index.lab_test'), style: :bold, align: :left
          end
        end
      end
      bounding_box([TITLE_ROW_STOP1, bounds.top], width: COLUMN_1_WIDTH, height: title_row_height) do
        pad_top PADDING do
          indent 0, 4 do
            text t('results.index.result'), style: :bold, align: :right
          end
        end
      end
      bounding_box([TITLE_ROW_STOP2, bounds.top], width: COLUMN_2_WIDTH, height: title_row_height) do
        pad_top PADDING do
          indent PADDING do
            text t('results.index.units'), style: :bold, align: :left
          end
        end
      end
      bounding_box([TITLE_ROW_STOP3, bounds.top], width: COLUMN_3_WIDTH, height: title_row_height) do
        pad_top PADDING do
          text t('results.index.flag'), style: :bold, align: :center
        end
      end
      bounding_box([TITLE_ROW_STOP4 + column_range_title_width, bounds.top], width: column_left_range_width + column_range_symbol_width + column_right_range_width, height: title_row_height) do
        pad_top PADDING do
          text t('results.index.range'), style: :bold, align: :center
        end
      end
    end

    move_down ROW_VERTICAL_PADDING
    line_width(LIGHT_RULE_WIDTH)
    stroke_horizontal_line(bounds.left, bounds.width)
    line_width(NORMAL_RULE_WIDTH)
  end

  def signature_image
    return unless @signature

    pad = current_user.descender? ? 40 : 20
    shim = current_user.descender? ? 22 : 18

    float do
      bounding_box([5, cursor + shim], width: 170, height: pad) do
        svg Base64.strict_decode64(current_user.signature), position: :center, height: pad if current_user.signature
      end
    end
  end

  def ranges_for_table(result)
    display_units(result) ? result.reference_intervals : []
  end

  def row_height
    font_size + 4
  end

  def title_row_height
    line_height * 1.5
  end

  def method_missing(...)
    @view.send(...)
  end
end
