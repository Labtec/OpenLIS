# frozen_string_literal: true

require_relative 'images/logo'

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

  FLASH_TAG_WIDTH = 80
  HALF_INCH = 36
  HEADING_INDENT = 20
  HEADING_PADDING = 5.5
  LINE_PADDING = 2
  LOGO_HEIGHT = 50
  LOGO_WIDTH = 150
  NOTES_INDENT = 45
  NOTES_PADDING = 7
  PADDING = 5
  ROW_VERTICAL_PADDING = 1
  SIGNATURE_BLOCK_SHIM = 75

  def initialize(patient, accession, results, view_context)
    @patient = patient
    @accession = accession
    @results = results
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
    file = File.expand_path('../fonts/MyriadPro', __FILE__)
    font_families['MyriadPro'] = {
      normal:      { file: file + '-Regular.ttf' },
      italic:      { file: file + '-SemiCnIt.ttf' },
      bold:        { file: file + '-Semibold.ttf' },
      bold_italic: { file: file + '-BoldSemiCnIt.ttf' }
    }

    file = File.expand_path('../fonts/HelveticaWorld', __FILE__)
    font_families['HelveticaWorld'] = {
      normal:      { file: file + '-Regular.ttf' },
      italic:      { file: file + '-Italic.ttf' },
      bold:        { file: file + '-Bold.ttf' },
      bold_italic: { file: file + '-BoldItalic.ttf' }
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
    column_6_padding_right = 40
    column_description_range_width = 70
    column_5_width = font_size - 2
    column_4_width = (column_range_width - column_description_range_width - column_5_width - column_6_padding_right) / 2
    column_6_width = column_4_width + column_6_padding_right
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
        text (t('results.index.preliminary') unless @accession.reported_at).to_s, align: :right, color: REPORT_COLORS[:red]
      end

      ##
      # Letterhead
      bounding_box([bounds.left, page_top - top_margin], width: bounds.width, height: header_height) do
        ##
        # Corporate logo
        translate(bounds.left, bounds.top - LOGO_HEIGHT) do
          logo
        end

        bounding_box([bounds.left + LOGO_WIDTH, bounds.top], width: bounds.width - LOGO_WIDTH, height: LOGO_HEIGHT) do
          pad_top HEADING_PADDING do
            indent HEADING_INDENT do
              font('MyriadPro') do
                text 'MasterLab—Laboratorio Clínico Especializado', size: 11, style: :bold
                text 'Villa Lucre • Consultorios Médicos San Judas Tadeo • Local 107', size: 9, color: COLORS[:gray]
                text 'Tel: 222-9200 ext. 1107 • Fax: 277-7832 • Email: masterlab@labtecsa.com', size: 9, color: COLORS[:gray]
                text 'Director: Lcdo. Erick Chu, TM, MSc', size: 9, color: COLORS[:gray]
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
              text t('results.index.identifier')
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
                text t('results.index.walk_in')
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
            text age(@patient.birthdate, @accession.drawn_at)
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
          bounding_box([title_row_stop4 + column_description_range_width / 2, bounds.top], width: column_range_width - column_description_range_width / 2, height: title_row_height) do
            pad_top PADDING do
              text t('results.index.range'), color: COLORS[:white], style: :bold, align: :center
            end
          end
          bounding_box([title_row_stop4 + column_description_range_width / 2, bounds.top], width: column_range_width - column_description_range_width / 2, height: title_row_height) do
            pad_top PADDING do
              text t('results.index.range'), color: COLORS[:purple], style: :bold, align: :center
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
      department_title = make_cell content: department.name, borders: [], font_style: :bold, padding: [PADDING, 0]
      blank_fill = make_cell content: nil, borders: []
      run_by = make_cell content: ([t('results.index.run_by'), @accession.reporter.initials, t('results.index.on_date'), l(@accession.reported_at, format: :long)].join(' ') if @accession.reported_at).to_s, font_style: :italic, size: 7.5, borders: [], align: :right
      data = [[department_title, blank_fill, blank_fill, blank_fill, run_by]]
      test_results.each do |result|
        if result.flag.present?
          cell_col0 = make_cell content: result.lab_test_name, background_color: REPORT_COLORS[:highlight_gray], inline_format: true
          cell_col1 = make_cell content: format_value(result).gsub(/</, '&lt; ').gsub(/&lt; i/, '<i').gsub(/&lt; s/, '<s').gsub(%r{&lt; \/}, '</'), background_color: REPORT_COLORS[:highlight_gray], inline_format: true
        else
          cell_col0 = make_cell content: result.lab_test_name, inline_format: true
          cell_col1 = make_cell content: format_value(result).gsub(/</, '&lt; ').gsub(/&lt; i/, '<i').gsub(/&lt; s/, '<s').gsub(%r{&lt; \/}, '</'), inline_format: true
        end
        cell_col3 = make_cell content: flag_name(result), font_style: :bold, text_color: FLAG_COLORS[flag_color(result).to_sym]
        ##
        # Ranges sub-table
        cell_col4 = make_table(result.ranges, cell_style: { padding: [0, 0.4], borders: [] }) do
          column(0).align = :right
          column(1).align = :right
          column(2).align = :center
          column(3).align = :left
          column(0).width = column_description_range_width
          column(1).width = column_4_width
          column(2).width = column_5_width
          column(3).width = column_6_width

          # TODO: padding should be done here
        end
        data << [cell_col0, cell_col1, result.unit_name, cell_col3, cell_col4]
      end

      table(data, header: true, cell_style: { padding: [LINE_PADDING, 0] }) do
        column(0).width = column_0_width
        column(1).width = column_1_width
        column(2).width = column_2_width
        column(3).width = column_3_width
        column(4).width = column_range_width
        rows(1..-1).columns(0..3).padding = [ROW_VERTICAL_PADDING, PADDING]
        rows(1..-1).columns(4..6).padding = [ROW_VERTICAL_PADDING, 0]
        row(1..-1).column(1).align = :right
        row(1..-1).column(3).align = :center
        row(1..-1).column(0).padding_left = 5
        row(1..-1).border_bottom_color = REPORT_COLORS[:light_gray]
        row(1..-1).borders = [:bottom]
        row(1..-1).border_width = 0.75
      end

      next if @accession.notes.find_by(department_id: department).try(:content).blank?
      pad NOTES_PADDING do
        indent NOTES_INDENT do
          text "#{t('results.index.notes')} #{@accession.notes.find_by(department_id: department).content}", color: COLORS[:purple], style: :bold_italic, inline_format: true
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
          pad_top PADDING do
            text current_user_name, align: :center
          end
          text registration_number, align: :center
        end
      end
    else
      if @accession.reported_at
        bounding_box([bounds.left + SIGNATURE_BLOCK_SHIM, bounds.bottom - line_height - PADDING], width: column_0_width, height: line_height) do
          pad_top LINE_PADDING do
            text t('results.index.reviewed_by'), align: :right
          end
        end
        bounding_box([SIGNATURE_BLOCK_SHIM + column_0_width + LINE_PADDING, cursor], width: signature_line, height: line_height + PADDING) do
          stroke_horizontal_rule
          pad_top PADDING do
            text current_user_name + registration_number(inline: true), align: :center
          end
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
            text "#{t('results.index.reported_at')} #{l(@accession.reported_at, format: :long) if @accession.reported_at}#{t('results.index.preliminary') unless @accession.reported_at}"
            text "#{t('results.index.printed_at')} #{l(Time.current, format: :long)}"
          end
        end
        bounding_box([bounds.left, bounds.top], width: bounds.width, height: footer_height) do
          pad_top PADDING do
            text "#{t('results.index.accession')} #{@accession.id}", align: :right
            text "#{t('results.index.results_of')} #{full_name(@patient)}", align: :right
            text (t('results.index.preliminary') unless @accession.reported_at).to_s, align: :right, color: REPORT_COLORS[:red]
          end
        end
      end
    end

    ##
    # Page number
    number_pages "#{t('results.index.page')} <page> #{t('results.index.of')} <total>", at: [bounds.left, page_bottom + footer_margin_bottom + page_number_height]
  end

  private

  def method_missing(*args, &block)
    @view.send(*args, &block)
  end
end
