# frozen_string_literal: true

require_relative 'images/logos/master_lab'
require 'barby'
require 'barby/barcode/data_matrix'
require 'barby/outputter/prawn_outputter'

class LabReport < Prawn::Document
  # Corporate colors
  COLORS = {
    black: [0, 0, 0, 100],
    white: [0, 0, 0, 0],
    gray: [0, 0, 0, 75],
    purple: [0, 100, 0, 50]
  }.freeze

  FLAG_COLORS = {
    high_value: [0, 100, 100, 0],
    low_value: [100, 100, 0, 0],
    abnormal_value: [0, 100, 0, 50]
  }.freeze

  REPORT_COLORS = {
    red: [0, 100, 100, 0],
    light_gray: [0, 0, 0, 10],
    highlight_gray: [0, 0, 0, 15]
  }.freeze

  BARCODE_HEIGHT = 15
  BARCODE_XDIM = 1.5
  FLASH_TAG_WIDTH = 80
  HALF_INCH = 36
  HEADING_INDENT = 20
  HEADING_PADDING = 5.5
  LINE_PADDING = 2
  LOGO_HEIGHT = 50
  LOGO_WIDTH = 150
  NOTES_INDENT = 25
  NOTES_PADDING = 7
  PADDING = 5
  ROW_VERTICAL_PADDING = 1
  SIGNATURE_BLOCK_SHIM = 75

  def initialize(patient, accession, results, signature, view_context)
    @patient = patient
    @accession = accession
    @results = results
    @signature = signature
    @view = view_context

    super(
      info: {
        Title: 'Reporte de Resultados',
        Author: 'MasterLab—Laboratorio Clínico Especializado',
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

    fill_color COLORS[:black]
    stroke_color COLORS[:black]

    ##
    # Constants
    # one_inch = HALF_INCH * 2
    # min_hp_print = 17
    # safe_print = HALF_INCH
    # fold = page.dimensions[3] / 3
    top_margin = page.margins[:top]
    # right_margin = page.margins[:right]
    bottom_margin = page.margins[:bottom]
    # left_margin = page.margins[:left]
    page_top = bounds.top + top_margin
    page_bottom = bounds.bottom - bottom_margin
    # page_left = bounds.left - left_margin
    footer_margin_bottom = HALF_INCH

    ##
    # Variables
    line_height = font_size + LINE_PADDING
    row_height = font_size + 4
    title_row_height = line_height * 1.5
    page_number_height = font_size - 0.25
    # number_of_rows = 600 / row_height
    footer_height = line_height * 3 + PADDING
    demographics_width1 = 45
    demographics_width2 = 155
    demographics_width3 = @patient.animal_type ? 40 : 30
    demographics_width4 = 80
    demographics_width5 = 80
    demographics_width6 = 150
    column_0_width = 140
    column_1_width = 80
    column_2_width = 88
    column_3_width = 40
    column_range_width = 192
    column_gender_range_width = 12
    column_description_range_width = 90
    column_range_title_width = column_gender_range_width + column_description_range_width
    column_5_width = font_size - 2
    column_4_width = (column_range_width - column_range_title_width - column_5_width) / 2
    # table_padding = 2
    signature_spacing = line_height * 3
    signature_line = 180
    patient_demographics_height = row_height * 3
    # window_height = 36 * 2.25
    # window_width = 36 * 9
    envelope_adjustment_height = 34
    header_height = LOGO_HEIGHT + envelope_adjustment_height + patient_demographics_height + title_row_height + PADDING * 2.5
    signature_block_height = signature_spacing + line_height * 3 + PADDING
    demographics_stop1 = demographics_width1
    demographics_stop2 = demographics_stop1 + demographics_width2
    demographics_stop3 = demographics_stop2 + demographics_width3
    demographics_stop4 = demographics_stop3 + demographics_width4
    demographics_stop5 = demographics_stop4 + demographics_width5
    title_row_stop1 = column_0_width
    title_row_stop2 = title_row_stop1 + column_1_width
    title_row_stop3 = title_row_stop2 + column_2_width
    title_row_stop4 = title_row_stop3 + column_3_width
    page.margins[:top] = header_height + top_margin

    ##
    # Folding marks and window (do not print)
    # horizontal_line page_left, page_left + min_hp_print, at: page_top - fold
    # horizontal_line page_left, page_left + min_hp_print, at: page_top - 2 * fold
    # rounded_rectangle [page_left + HALF_INCH / 2, page_top - fold + one_inch + window_height], window_width, window_height, 10

    ##
    # Header
    repeat :all do
      ##
      # Flash tag top
      bounding_box([bounds.right - FLASH_TAG_WIDTH, page_top - HALF_INCH - line_height], width: FLASH_TAG_WIDTH, height: line_height) do
        text t("results.index.#{@accession.status}"), align: :right, color: REPORT_COLORS[:red]
      end
      bounding_box([bounds.right - barcode_width, page_top - HALF_INCH - 2.4 * line_height], width: barcode_width, height: BARCODE_HEIGHT + line_height) do
        barcode
      end
      bounding_box([bounds.right - barcode_width, page_top - HALF_INCH - 3.6 * line_height - BARCODE_HEIGHT], width: barcode_width, height: BARCODE_HEIGHT + 2 * line_height) do
        font('OCRB') do
          text @accession.id.to_s, size: 5, align: :center
        end
      end

      ##
      # Letterhead
      bounding_box([bounds.left, page_top - top_margin], width: bounds.width, height: header_height) do
        ##
        # Corporate logo
        translate(bounds.left, bounds.top - LOGO_HEIGHT) do
          logo_master_lab
        end

        bounding_box([bounds.left + LOGO_WIDTH, bounds.top], width: bounds.width - LOGO_WIDTH, height: LOGO_HEIGHT) do
          pad_top HEADING_PADDING do
            indent HEADING_INDENT do
              font('MyriadPro') do
                text 'MasterLab—Laboratorio Clínico Especializado', size: 11, style: :bold
                text 'Villa Lucre • Consultorios Médicos San Judas Tadeo • Local 107', size: 9, color: COLORS[:gray]
                text 'Tel: 222-9200 ext. 1107 • Fax: 277-7832 • Móvil: 6869-5210', size: 9, color: COLORS[:gray]
                text 'Email: masterlab@labtecsa.com • Director: Lcdo. Erick Chu, TM, MSc', size: 9, color: COLORS[:gray]
              end
            end
          end
        end

        bounding_box([bounds.left, bounds.top - LOGO_HEIGHT], width: bounds.width, height: envelope_adjustment_height) do
        end

        stroke_horizontal_rule

        ##
        # Patient demographics
        bounding_box([bounds.left, cursor - PADDING * 2], width: bounds.width, height: patient_demographics_height) do
          bounding_box([bounds.left, bounds.top], width: demographics_width1, height: row_height) do
            indent PADDING do
              text t('results.index.full_name'), style: :bold
            end
          end
          bounding_box([bounds.left, bounds.top - row_height], width: demographics_width1, height: row_height) do
            indent PADDING do
              text t("results.index.#{@patient.identifier_type}") if @patient.identifier_type
            end
          end
          if @accession.doctor
            bounding_box([bounds.left, bounds.top - 2 * row_height], width: demographics_width1, height: row_height) do
              indent PADDING do
                text t('results.index.doctor')
              end
            end
          else
            bounding_box([bounds.left, bounds.top - 2 * row_height], width: demographics_width1 + demographics_width2, height: row_height) do
              indent PADDING do
                text t('results.index.outpatient')
              end
            end
          end
          text_box full_name(@patient), at: [demographics_stop1, bounds.top],
                                        width: demographics_width2 +
                                               demographics_width3 +
                                               demographics_width4,
                                        height: row_height,
                                        overflow: :shrink_to_fit,
                                        style: :bold
          bounding_box([demographics_stop1, bounds.top - row_height], width: demographics_width2, height: row_height) do
            text @patient.identifier
          end
          bounding_box([demographics_stop1, bounds.top - 2 * row_height], width: demographics_width2, height: row_height) do
            text @accession.doctor_name if @accession.doctor
          end

          ########################

          if @patient.animal_type
            bounding_box([demographics_stop2, bounds.top], width: demographics_width3, height: row_height) do
              text t('results.index.type'), style: :bold
            end
          end
          bounding_box([demographics_stop2, bounds.top - row_height], width: demographics_width3, height: row_height) do
            text t('results.index.age')
          end
          bounding_box([demographics_stop2, bounds.top - 2 * row_height], width: demographics_width3, height: row_height) do
            text t('results.index.gender')
          end
          if @patient.animal_type
            bounding_box([demographics_stop3, bounds.top], width: demographics_width4, height: row_height) do
              text animal_species_name(@patient.animal_type), style: :bold
            end
          end
          bounding_box([demographics_stop3, bounds.top - row_height], width: demographics_width4, height: row_height) do
            text display_pediatric_age(@accession.subject_age)
          end
          bounding_box([demographics_stop3, bounds.top - 2 * row_height], width: demographics_width4, height: row_height) do
            text gender(@patient.gender)
          end

          ########################

          bounding_box([demographics_stop4, bounds.top], width: demographics_width5, height: row_height) do
            text t('results.index.accession'), style: :bold
          end
          bounding_box([demographics_stop4, bounds.top - row_height], width: demographics_width5, height: row_height) do
            text t('results.index.drawn_at')
          end
          bounding_box([demographics_stop4, bounds.top - 2 * row_height], width: demographics_width5, height: row_height) do
            text t('results.index.received_at')
          end
          bounding_box([demographics_stop5, bounds.top], width: demographics_width6, height: row_height) do
            text @accession.id.to_s, style: :bold
          end
          bounding_box([demographics_stop5, bounds.top - row_height], width: demographics_width6, height: row_height) do
            text l(@accession.drawn_at, format: :long)
          end
          bounding_box([demographics_stop5, bounds.top - 2 * row_height], width: demographics_width6, height: row_height) do
            text l(@accession.received_at, format: :long)
          end
        end

        ##
        # Report Header
        fill_color REPORT_COLORS[:light_gray]
        fill_and_stroke do
          rectangle [bounds.left, bounds.bottom + title_row_height], bounds.width, title_row_height
        end
        fill_color COLORS[:black]

        bounding_box([bounds.left, bounds.bottom + title_row_height], width: bounds.width, height: title_row_height) do
          bounding_box([bounds.left, bounds.top], width: column_0_width, height: title_row_height) do
            pad_top PADDING do
              indent PADDING do
                text t('results.index.lab_test'), style: :bold, align: :left
              end
            end
          end
          bounding_box([title_row_stop1, bounds.top], width: column_1_width, height: title_row_height) do
            pad_top PADDING do
              indent 0, PADDING do
                text t('results.index.result'), style: :bold, align: :right
              end
            end
          end
          bounding_box([title_row_stop2, bounds.top], width: column_2_width, height: title_row_height) do
            pad_top PADDING do
              indent PADDING do
                text t('results.index.units'), style: :bold, align: :left
              end
            end
          end
          bounding_box([title_row_stop3, bounds.top], width: column_3_width, height: title_row_height) do
            pad_top PADDING do
              text t('results.index.flag'), style: :bold, align: :center
            end
          end
          [:white, :purple].each do |color|
            bounding_box([title_row_stop4 + column_range_title_width, bounds.top], width: column_4_width * 2 + column_5_width, height: title_row_height) do
              pad_top PADDING do
                text t('results.index.range'), color: COLORS[color], style: :bold, align: :center
              end
            end
          end
        end
      end
    end

    ##
    # Begin report

    ##
    # Results table
    @results.each do |department, test_results|
      next unless test_results.map(&:performed?).any?

      department_title = make_cell content: department.name, font_style: :bold, padding: [LINE_PADDING, 0]
      if @accession.reported_at
        run_by = make_cell content: [t('results.index.run_by'), @accession.reporter.initials, t('results.index.on_date'), l(@accession.reported_at, format: :long)].join(' ').to_s, font_style: :italic, size: 7.5, colspan: 2, align: :right, padding: [LINE_PADDING, 0]
        data = [[department_title, '', '', run_by]]
      else
        data = [[department_title, '', '', '', '']]
      end
      test_results.each do |result|
        next if result.not_performed?

        if !result.normal?
          cell_col0 = make_cell content: result.lab_test_name, background_color: REPORT_COLORS[:highlight_gray], inline_format: true, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
          cell_col1 = make_cell content: format_value(result).gsub(/</, '&lt; ').gsub(/&lt; i/, '<i').gsub(/&lt; s/, '<s').gsub(%r{&lt; /}, '</'), background_color: REPORT_COLORS[:highlight_gray], inline_format: true, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
        else
          cell_col0 = make_cell content: result.lab_test_name, inline_format: true, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
          cell_col1 = make_cell content: format_value(result).gsub(/</, '&lt; ').gsub(/&lt; i/, '<i').gsub(/&lt; s/, '<s').gsub(%r{&lt; /}, '</'), inline_format: true, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
        end
        cell_col2 = make_cell content: format_units(result), padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
        cell_col3 = make_cell content: flag_name(result), font_style: :bold, text_color: FLAG_COLORS[flag_color(result).to_sym], padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, PADDING]
        ##
        # Ranges sub-table
        pdf_ranges_table = make_table(ranges_table(result.reference_ranges, display_gender: @patient.unknown?), cell_style: { padding: [0, 0.4], borders: [] }) do
          column(0).align = :right
          column(1).align = :right
          column(2).align = :right
          column(3).align = :center
          column(4).align = :left
          column(0).width = column_description_range_width
          column(1).width = column_gender_range_width
          column(2).width = column_4_width
          column(3).width = column_5_width
          column(4).width = column_4_width
        end
        cell_col4 = make_cell content: pdf_ranges_table, padding: [ROW_VERTICAL_PADDING, PADDING, ROW_VERTICAL_PADDING, 0]

        if result.lab_test_remarks.present?
          remarks = make_cell content: result.lab_test_remarks.to_s, inline_format: true, colspan: 5, size: 7, padding: [0, PADDING, ROW_VERTICAL_PADDING, PADDING * 2]

          data_remarks = [[cell_col0, cell_col1, cell_col2, cell_col3, cell_col4]]
          data_remarks << [remarks]

          data_remarks_table = make_table(data_remarks, cell_style: { borders: [] }) do
            column(0).width = column_0_width
            column(1).width = column_1_width
            column(2).width = column_2_width
            column(3).width = column_3_width
            column(4).width = column_range_width
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
        column(0).width = column_0_width
        column(1).width = column_1_width
        column(2).width = column_2_width
        column(3).width = column_3_width
        column(4).width = column_range_width
        row(0).borders = []
        row(1..-1).column(1).align = :right
        row(1..-1).column(3).align = :center
        row(1..-1).border_bottom_color = REPORT_COLORS[:light_gray]
        row(1..-1).borders = [:bottom]
        row(1..-1).border_width = 0.75
      end

      next if @accession.notes.find_by(department_id: department).try(:content).blank?

      pad NOTES_PADDING do
        bounding_box([NOTES_INDENT, cursor + LINE_PADDING], width: bounds.width - NOTES_INDENT) do
          text t('results.index.notes'), color: COLORS[:purple], style: :bold
          text @accession.notes.find_by(department_id: department).content, inline_format: true

          stroke_color COLORS[:purple]
          self.line_width = 2
          stroke do
            vertical_line bounds.top + LINE_PADDING, bounds.bottom + LINE_PADDING, at: bounds.left - PADDING
          end
          self.line_width = 1
          stroke_color COLORS[:black]
        end
      end
    end

    ##
    # End of report
    horizontal_rule

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
          stroke_horizontal_rule
          signature_image
          pad_top PADDING do
            text current_user_name, align: :center
          end
          text registration_number, align: :center
        end
      end
    elsif @accession.reported_at
      bounding_box([bounds.left + SIGNATURE_BLOCK_SHIM, bounds.bottom - line_height - PADDING], width: column_0_width, height: line_height) do
        pad_top LINE_PADDING do
          text t('results.index.reviewed_by'), align: :right
        end
      end
      bounding_box([SIGNATURE_BLOCK_SHIM + column_0_width + LINE_PADDING, cursor], width: signature_line, height: line_height + PADDING) do
        stroke_horizontal_rule
        signature_image
        pad_top PADDING do
          text current_user_name + registration_number(inline: true), align: :center
        end
      end
    end

    ##
    # Footer
    repeat :all do
      bounding_box([bounds.left, page_bottom + footer_height + footer_margin_bottom], width: bounds.width, height: footer_height) do
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
            text t("results.index.#{@accession.status}"), align: :right, color: REPORT_COLORS[:red]
          end
        end
      end
    end

    ##
    # Page number
    number_pages "#{t('results.index.page')} <page> #{t('results.index.of')} <total>", at: [bounds.left, page_bottom + footer_margin_bottom + page_number_height]
  end

  private

  def barcode
    barcode = Barby::DataMatrix.new(@accession.id.to_s)
    barcode.annotate_pdf(self, xdim: BARCODE_XDIM)
  end

  def barcode_width
    length = @accession.id.to_s.length
    (length + 7) * BARCODE_XDIM
  end

  def method_missing(*args, &block)
    @view.send(*args, &block)
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
end
