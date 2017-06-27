# frozen_string_literal: true

require_relative 'images/logo'

class LabPriceList < Prawn::Document
  def initialize(priceable, prices, view_context)
    @priceable = priceable
    @prices = prices
    @view = view_context

    super(
      info: {
        Title: 'Lista de Precios',
        Author: 'MasterLab—Laboratorio Clínico Especializado',
        Subject: '',
        Producer: 'MasterLab',
        Creator: 'MasterLab',
        CreationDate: Time.current,
        Keywords: 'precio lista prueba laboratorio'
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
    # Corporate colors
    colors = {
      black: [0, 0, 0, 100],
      white: [0, 0, 0, 0],
      gray: [0, 0, 0, 10],
      highlight_gray: [0, 0, 0, 15],
      logo_gray: [0, 0, 0, 75],
      high_value: [0, 100, 100, 0],
      low_value: [100, 100, 0, 0],
      abnormal_value: [0, 100, 0, 50]
    }

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

    fill_color colors[:black]
    stroke_color colors[:black]

    ##
    # Constants
    # half_inch = 36
    # one_inch = half_inch * 2
    # min_hp_print = 17
    # safe_print = half_inch
    # fold = page.dimensions[3] / 3
    top_margin = page.margins[:top]
    # right_margin = page.margins[:right]
    # bottom_margin = page.margins[:bottom]
    # left_margin = page.margins[:left]
    page_top = bounds.top + top_margin
    # page_bottom = bounds.bottom - bottom_margin
    # page_left = bounds.left - left_margin

    ##
    # Variables
    line_padding = 2
    # row_vertical_padding = 1
    line_height = font_size + line_padding
    row_height = font_size + 4 + 2 # Helvetica Neue has less leading
    title_row_height = line_height * 1.5
    # page_number_height = font_size - 0.25
    # notes_padding = 7
    # notes_indent = 45
    # number_of_rows = 600 / row_height
    padding = 5
    # footer_margin_bottom = half_inch
    heading_padding = 5.5
    heading_indent = 20
    # footer_height = line_height * 3 + padding
    logo_width = 150
    logo_height = 50
    # flash_tag_width = 80
    name_width = 150
    procedure_width = 50
    price_width = 50
    table_padding = 2
    # signature_spacing = line_height * 3
    # signature_line = 180
    patient_demographics_height = row_height * 3
    # window_height = 36 * 2.25
    # window_width = 36 * 9
    envelope_adjustment_height = 34
    header_height = logo_height + envelope_adjustment_height + patient_demographics_height + title_row_height + padding * 2.5
    # signature_block_height = signature_spacing + line_height * 2 + padding
    page.margins[:top] = header_height + top_margin

    ##
    # Folding marks and window (do not print)
    # horizontal_line page_left, page_left + min_hp_print, at: page_top - fold
    # horizontal_line page_left, page_left + min_hp_print, at: page_top - 2 * fold
    # rounded_rectangle [page_left + half_inch / 2, page_top - fold + one_inch + window_height], window_width, window_height, 10

    ##
    # Header
    repeat :all do
      ##
      # Letterhead
      bounding_box([bounds.left, page_top - top_margin], width: bounds.width, height: header_height) do
        ##
        # Corporate logo
        translate(bounds.left, bounds.top - logo_height) do
          logo
        end

        bounding_box([bounds.left + logo_width, bounds.top], width: bounds.width - logo_width, height: logo_height) do
          pad_top heading_padding do
            indent heading_indent do
              font('MyriadPro') do
                text 'MasterLab—Laboratorio Clínico Especializado', size: 11, style: :bold
                text 'Villa Lucre • Consultorios Médicos San Judas Tadeo • Local 107', size: 9, color: colors[:logo_gray]
                text 'Tel: 222-9200 ext. 1107 • Fax: 277-7832 • Email: masterlab@labtecsa.com', size: 9, color: colors[:logo_gray]
                text 'Director: Lcdo. Erick Chu, TM, MSc', size: 9, color: colors[:logo_gray]
              end
            end
          end
        end

        move_down 25
        text 'Lista de Precios', align: :center, size: 10, style: :bold
        if @priceable
          text @priceable.name, align: :center, size: 10, style: :bold
        end

        move_down 5

        # Manually add second column title or fix bug in prawn
      end
    end

    column_box [0, cursor], width: bounds.width, columns: 2 do
      # Prices Table
      prices_table = [['Prueba', 'CPT', 'Precio (B/.)']]
      @prices.map do |price|
        prices_table += [[
          price.priceable.name,
          price.priceable.procedure,
          @view.number_with_precision(price.amount, precision: 2)
        ]]
      end

      table prices_table,
            header: true,
            # :position => :center, # This breaks the column layout
            column_widths: { 0 => name_width, 1 => procedure_width, 2 => price_width },
            row_colors: [colors[:white], colors[:gray]],
            cell_style: { inline_format: true } do |t|
        t.cells.borders = []
        t.cells.height = row_height
        t.cells.padding = table_padding
        t.column(0).style align: :left
        t.column(1).style align: :center
        t.column(2).style align: :right
        t.before_rendering_page do |page|
          page.row(0).border_top_color = colors[:black]
          page.row(0).border_top_width = 1
          page.row(0).border_bottom_color = colors[:black]
          page.row(0).border_bottom_width = 0.5
          page.row(0).borders = %i[top bottom]
          page.row(0).font_style = :bold
          page.row(-1).border_bottom_color = colors[:black]
          page.row(-1).border_bottom_width = 1
          page.row(-1).borders = [:bottom]
        end
      end
    end
  end
end
