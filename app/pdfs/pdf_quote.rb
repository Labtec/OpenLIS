# frozen_string_literal: true

require_relative 'images/logos/master_lab'

class PDFQuote < Prawn::Document
  HALF_INCH = 36

  ENVELOPE_ADJUSTMENT_HEIGHT = 20
  FOOTER_MARGIN_BOTTOM = HALF_INCH
  FOOTNOTE_SYMBOLS = %w[* † ‡ § ¶ ‖ ** †† ‡‡].freeze
  HEADING_INDENT = 20
  HEADING_PADDING = 5.5
  HEAVY_RULE_WIDTH = 2
  LINE_PADDING = 2
  LIGHT_RULE_WIDTH = 0.5
  LOGO_HEIGHT = 50
  LOGO_WIDTH = 150
  NORMAL_RULE_WIDTH = 1
  NOTES_INDENT = 19
  NOTES_PADDING = 7
  PADDING = 5
  TABLE_ROW_HEIGHT = 31

  ##
  # Folding marks and window (do not print)
  # ONE_INCH = HALF_INCH * 2
  # PRINT_SAFETY_AREA = 17
  # WINDOW_HEIGHT = 36 * 2.25
  # WINDOW_WIDTH = 36 * 9

  def initialize(quote, signature, view_context)
    @quote = quote
    @signature = signature
    @view = view_context

    super(
      info: {
        Title: "#{t('quotes.show.title')} ##{@quote.serial_number}",
        Author: 'MasterLab—Laboratorio Clínico Especializado',
        Creator: 'MasterLab',
        Producer: 'MasterLab',
        CreationDate: @quote.created_at,
        ModDate: @quote.updated_at
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

    ##
    # Variables
    page.margins[:top]
    bottom_margin = page.margins[:bottom]
    bounds.top
    page_bottom = bounds.bottom - bottom_margin
    form_padding = 4
    table_padding = 2
    footer_height = line_height * 1 + PADDING
    line_number_width = 30
    description_width = 195
    code_width = 50
    subtotal_width = 80
    discount_width = 60
    quantity_width = 40
    page_number_height = font_size - 0.25
    insurance_providers_box_height = (line_height + LINE_PADDING) * 3
    payment_info_box_height = (line_height + LINE_PADDING) * 4
    total_price_width = bounds.width - (line_number_width + description_width + code_width + subtotal_width + discount_width + quantity_width)
    quote_endnotes = []

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
    letterhead
    move_down ENVELOPE_ADJUSTMENT_HEIGHT

    text @view.l(@quote.approved_at.to_date, format: :with_month_name).to_s, align: :right
    text "#{t('quotes.show.title')} #{t('quotes.show.number')} <b>#{@quote.serial_number}</b>", inline_format: true, align: :right
    text "#{t('quotes.show.validity')}  #{t('datetime.distance_in_words.x_days', count: Quote::VALIDITY_DURATION.in_days.to_i)}", align: :right

    move_down 25

    ##
    # Title
    text "<b>#{t('quotes.show.title').upcase}</b>", align: :center, inline_format: true, size: 10
    move_down 10

    to_from_position = cursor

    ##
    # To
    bounding_box([0, to_from_position], width: bounds.width / 2 - PADDING, height: line_height * 4 + LINE_PADDING) do
      contact_name
      contact_email
      contact_phone
      requested_by
    end

    ##
    # From
    bounding_box([bounds.width / 2 + PADDING, to_from_position], width: bounds.width / 2 - PADDING, height: line_height * 4 + LINE_PADDING) do
      text "\n" * 3
      signature_image
      text "#{t('quotes.show.approved_by')}  #{@view.approved_by_name(@quote.approved_by)}"
    end

    move_down 25

    ##
    # Quote Table
    quote_table = [["<b>#{t('quotes.show.number')}</b>", "<b>#{t('quotes.show.description')}</b>", "<b>#{t('quotes.show.code')}</b>", "<b>#{t('quotes.show.price')}</b>", "<b>#{t('quotes.show.discount') unless @quote.total_discount.zero?}</b>", "<b>#{t('quotes.show.quantity')}</b>", "<b>#{t('quotes.show.total')}</b>"]]
    @quote.line_items.each_with_index.map do |line_item, index|
      quote_table += [[
        index + 1,
        "#{@view.quote_line_item_description(line_item)}#{add_mark(line_item, quote_endnotes)}",
        @view.quote_line_item_code(line_item),
        @view.number_to_currency(line_item.list_price, locale: 'en'),
        line_item_discount(line_item.discount),
        line_item.quantity,
        @view.number_to_currency(line_item.total_price, locale: 'en')
      ]]
    end

    table quote_table,
          header: true,
          position: :center,
          column_widths: { 0 => line_number_width, 1 => description_width, 2 => code_width, 3 => subtotal_width, 4 => discount_width, 5 => quantity_width, 6 => total_price_width },
          row_colors: [colors_white, colors_light_gray],
          cell_style: { padding: [0, table_padding, form_padding, table_padding], valign: :center, inline_format: true } do |t|
      t.cells.borders = []
      t.column(0).style align: :right
      t.column(0).style padding: [0, 3 * table_padding, form_padding, table_padding]
      t.column(1).style align: :left
      t.column(2).style align: :center
      t.column(3).style align: :right
      t.column(4).style align: :right
      t.column(5).style align: :center
      t.column(6).style align: :right
      t.row(0).border_top_color = colors_black
      t.row(0).border_top_width = HEAVY_RULE_WIDTH
      t.row(0).border_bottom_color = colors_black
      t.row(0).border_bottom_width = LIGHT_RULE_WIDTH
      t.row(0).borders = %i[top bottom]

      t.row(-1).border_top_color = colors_black
      t.row(-1).border_top_width = NORMAL_RULE_WIDTH
      t.row(-1).borders = %i[bottom]
    end

    ##
    # Totals Table
    totals_table = [[t('quotes.show.subtotal').to_s, @view.number_to_currency(@quote.subtotal, locale: :en).to_s]]
    totals_table += [[total_discount, @view.number_to_currency(@quote.total_discount, locale: :en).to_s]] unless @quote.total_discount.zero?
    totals_table += [[t('quotes.show.taxes').to_s, @view.number_to_currency(0, locale: :en).to_s]]
    totals_table += [[t('quotes.show.shipping_and_handling').to_s, @view.number_to_currency(@quote.shipping_and_handling, locale: :en).to_s]] unless @quote.shipping_and_handling.zero?
    totals_table += [["<b>#{t('quotes.show.grand_total')}</b>", "<b>#{@view.number_to_currency(@quote.grand_total, locale: :en)}</b>"]]
    totals_table_box_height = TABLE_ROW_HEIGHT * totals_table.size / 2

    page_break?(totals_table_box_height)

    bounding_box([bounds.left, cursor], width: bounds.width, height: totals_table_box_height) do
      table totals_table,
            header: false,
            position: :center,
            column_widths: { 0 => line_number_width + description_width + code_width + subtotal_width + discount_width + quantity_width, 1 => total_price_width },
            row_colors: [colors_white],
            cell_style: { padding: [0, table_padding, form_padding, table_padding], valign: :center, inline_format: true } do |t|
        t.cells.borders = []
        t.column(0).style align: :right
        t.column(0).style padding: [0, 3 * table_padding, form_padding, table_padding]
        t.column(1).style align: :right
        t.row(0).borders = %i[top]
        t.row(0).border_top_color = colors_black
        t.row(0).border_top_width = NORMAL_RULE_WIDTH
      end
    end

    move_down 25

    ##
    # Note
    if @quote.note.present?
      data_notes_padding_top = make_cell(content: '', height: NOTES_PADDING, borders: [])
      data_notes_padding_bottom = make_cell(content: '', height: PADDING, borders: [])
      data_notes_title = make_cell(content: t('results.index.notes'), inline_format: true, borders: [:left], text_color: colors_purple, font_style: :bold)
      data_notes_contents = make_cell(content: @view.render_markdown_pdf(@quote.note), inline_format: true, borders: [:left])
      data_notes = [[data_notes_padding_top]]
      data_notes << [data_notes_title]
      data_notes << [data_notes_contents]
      data_notes << [data_notes_padding_bottom]
      data_notes_table = make_table(data_notes, header: true, cell_style: { padding: [0, 0, 0, PADDING], width: bounds.width - NOTES_INDENT, border_left_color: colors_purple, border_width: HEAVY_RULE_WIDTH }, position: :right)
      data_notes_cell = make_cell(content: data_notes_table, colspan: 5, borders: [])

      table([[data_notes_cell]])

      move_down 5
    end

    ##
    # Endnotes
    if quote_endnotes
      quote_endnotes.each_with_index do |endnote, index|
        text "#{index + 1}.  #{endnote}", inline_format: true
      end
    end

    ##
    # Footnotes
    # Fasting
    if @quote.line_items.map(&:fasting_status_duration).any?
      text "#{FOOTNOTE_SYMBOLS[0]}Se recomienda un ayuno de 12 horas, a menos que lo indique la solicitud.", inline_format: true
    else
      text "No se requiere ayuno.", inline_format: true
    end
    # Legal
    if @quote.patient_retiree?
      text "<sup>#{FOOTNOTE_SYMBOLS[1]}</sup>Todos los panameños o extranjeros residentes en el territorio nacional con cincuenta y cinco años (55) o más si son mujeres con sesenta años (60) o más si son hombres, y los pensionados por invalidez de menor edad, gozarán de un descuento de 20%.", inline_format: true
    end

    move_down 15

    page_break?(insurance_providers_box_height)

    ##
    # Insurance Providers
    bounding_box([bounds.left, cursor], width: bounds.width, height: insurance_providers_box_height) do
      text 'Compañías aseguradoras afiliadas:'
      logo_axa_bw
    end

    move_down 10

    page_break?(payment_info_box_height)

    ##
    # Payment Info
    text 'Aceptamos tarjetas de crédito y débito.'

    payment_position = cursor
    bounding_box([bounds.left, payment_position], width: bounds.width / 2, height: payment_info_box_height) do
      text 'Los pagos correspondientes deben realizarse a nombre de:'
      indent PADDING do
        text 'LABTEC, S.A.'
        text 'RUC 299497-1-409892 DV 13'
      end
    end
    bounding_box([bounds.left + bounds.width / 2, payment_position], width: bounds.width / 4, height: payment_info_box_height) do
      text 'Para transferencias ACH:'
      indent PADDING do
        text 'Banco General'
        text 'Cuenta Corriente'
        text '03-21-01-009835-2'
      end
    end
    bounding_box([bounds.left + bounds.width * 3 / 4, payment_position], width: bounds.width / 4, height: payment_info_box_height) do
      text 'Para pagar con Yappi:'
      indent PADDING do
        bounding_box([bounds.left, cursor], width: 42, height: 35) do
          text '@masterlab'
        end
      end
    end

    ##
    # Footer
    repeat :all do
      bounding_box([bounds.left, page_bottom + footer_height + FOOTER_MARGIN_BOTTOM], width: bounds.width, height: footer_height) do
        text 'DOCUMENTO NO FISCAL', style: :bold, size: 6
      end
    end

    ##
    # Page number
    return unless page_count > 1

    number_pages "#{t('results.index.page').upcase} <page> #{t('results.index.of').upcase} <total>", at: [bounds.left, page_bottom + FOOTER_MARGIN_BOTTOM + page_number_height], size: 6
  end

  private

  def add_mark(item, endnotes_array)
    return "#{FOOTNOTE_SYMBOLS[0]}" if item.fasting_status_duration.present?

    return if item.patient_preparation.blank?

    endnotes_array << @view.render_markdown_pdf(item.patient_preparation)
    "<sup>#{endnotes_array.size}</sup>"
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

  def colors_black
    @signature ? '000000' : [0, 0, 0, 100]
  end

  def colors_gray
    @signature ? '404040' : [0, 0, 0, 75]
  end

  def colors_light_gray
    @signature ? 'E6E6E6' : [0, 0, 0, 10]
  end

  def colors_purple
    @signature ? '800080' : [0, 100, 0, 50]
  end

  def colors_white
    @signature ? 'FFFFFF' : [0, 0, 0, 0]
  end

  def contact_email
    if @quote&.patient&.email
      text "#{t('patients.card.email')}  #{@quote.patient.email}"
    else
      text "\n"
    end
  end

  def contact_name
    if @quote&.patient
      text "#{t('patients.quote.to')}  <strong>#{@view.full_name(@quote.patient)}</strong>", inline_format: true
    else
      text "\n"
    end
  end

  def contact_phone
    if @quote&.patient&.cellular
      text "#{t('patients.patient.cellular')}  #{@view.format_phone_number(@quote.patient.cellular)}"
    elsif @quote&.patient&.phone
      text "#{t('patients.patient.phone')}  #{@view.format_phone_number(@quote.patient.phone)}"
    else
      text "\n"
    end
  end

  def header_height
    ENVELOPE_ADJUSTMENT_HEIGHT
  end

  def line_height
    font_size + LINE_PADDING
  end

  def line_item_discount(discount)
    return if @quote.total_discount.zero?

    @view.number_to_currency(discount, locale: 'en')
  end

  def logo_axa_bw
    bounding_box([PADDING, cursor], width: 25, height: 25) do
      move_up 3
      svg File.read('app/assets/images/axa_bw.svg')
    end
  end

  def page_break?(next_box)
    start_new_page unless cursor > bounds.bottom + next_box
  end

  def requested_by
    if @quote.doctor
      text "#{t('results.index.ordered_by')}  #{@view.organization_or_practitioner(@quote.doctor)}", overflow: :shrink_to_fit
    else
      text "\n"
    end
  end

  def signature_image
    return unless @signature

    pad = @quote.approved_by.descender? ? 40 : 20
    shim = @quote.approved_by.descender? ? 27 : 23

    float do
      bounding_box([PADDING, cursor + shim], width: 170, height: pad) do
        svg Base64.strict_decode64(@quote.approved_by.signature), position: :center, height: pad if @quote.approved_by.signature
      end
    end
  end

  def total_discount
    if @quote.patient_retiree?
      "#{t('quotes.show.pdf_total_discount')}<sup>#{FOOTNOTE_SYMBOLS[1]}</sup>:"
    else
      t('quotes.show.total_discount')
    end
  end

  def method_missing(...)
    @view.send(...)
  end
end
