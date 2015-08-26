require 'matrix'
require_relative 'images/logo_labtec'

class AccountStatement < Prawn::Document

  def initialize(provider, statement, date, view_context)
    @provider = provider
    @statement = statement
    @date = date
    @view = view_context

    super(
      info: {
        :Title => 'Estado de Cuenta',
        :Author => 'MasterLab—Laboratorio Clínico Especializado',
        :Subject => '',
        :Creator => 'Labtec, S.A.',
        :Producer => 'Labtec, S.A.',
        :CreationDate => Time.current
      },
      inline: true,
      # Letter (8.5 x 11 in) is 612 x 792
      top_margin: 60,
      # right_margin: 36, # 0.5 in
      bottom_margin: 36,
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
    file = File.expand_path('../fonts/HelveticaWorld', __FILE__)
    font_families['HelveticaWorld'] = {
      :normal      => { :file => file + '-Regular.ttf' },
      :italic      => { :file => file + '-Italic.ttf' },
      :bold        => { :file => file + '-Bold.ttf' },
      :bold_italic => { :file => file + '-BoldItalic.ttf' }
    }

    font 'HelveticaWorld', size: 8

    # BEGIN DOCUMENT

    # Corporate logo
    translate(bounds.left, bounds.top - 50) do
      logo_labtec
    end

    fill_color colors[:black] # Otherwise takes the color of the logo

    bounding_box([bounds.left, bounds.top - 60], :width => 200, :height => 80) do
      text 'Labtec, S.A.', :size => 7
      text 'R.U.C. 299497-1-409892 D.V. 13', :size => 7
      text 'Villa Lucre, Consultorios Médicos San Judas Tadeo, 107', :size => 7
      text 'DOCUMENTO NO FISCAL', :size => 7, :style => :bold
    end

    bounding_box([bounds.right - 180, bounds.top - 50], :width => 180, :height => 30) do
      text "Del #{@view.time_period(date)}", :align => :center
      text "Cuenta: <b>#{provider.id.to_s.rjust(7, '0')}</b>", :inline_format => true, :align => :center
    end

    bounding_box([bounds.right - 180, bounds.top - (50 + 30)], :width => 180, :height => 80) do
      # TODO: make as table header
      table([['INFORMACIÓN DE CONTACTO']], :cell_style => {:borders => [], :padding => [0, 0], :font_style => :bold, :size => 10 }) do
        column(0).align = :center
        column(0).width = 180
        row(0).borders = [:top, :bottom]
        row(0).border_width = 1.5
        row(0).padding_top = 2
      end
      contact_info = [
        ['Correo electrónico:', '<b>masterlab@labtecsa.com</b>'],
        ['Teléfono:', '<b>277-7600 ext. 107</b>'],
        ['Fax:', '277-7832'],
      ]
      pad_top 2 do
        table(contact_info, :cell_style => { :borders => [], :inline_format => true, :padding => [0, 0] }) do
          column(0).align = :left
          column(0).width = 80
          column(1).align = :right
          column(1).width = 100
        end
      end
    end

    bounding_box([bounds.left, bounds.top - (60 + 80)], :width => 200, :height => 80) do
      text provider.name.mb_chars.upcase
      text provider.address.mb_chars.upcase if false # provider.address
      text "Tel: #{provider.phone}" if false # provider.phone
    end

    # Statement Summary
    bounding_box [bounds.left, bounds.top - (60 + 80 + 80)], :width => 160, :height => 18 do
      stroke_bounds
      pad_top 4 do
        text 'RESUMEN', :size => 14, :style => :bold, :align => :center
      end
    end
    stroke_horizontal_line bounds.left + 160 + 2, bounds.right, :at => cursor + 3
    draw_text 'Estado de Cuenta', :at => [bounds.left + 160 + 2 + 5, cursor + 3 + 5]

    ##
    # Summary table
    header = ['', 'MONTO']
    data = [header]
    data << ['Saldo Anterior', @view.number_to_currency('0.00', :unit => 'B/. ')]
    data << ['Pagos', '0.00']
    data << ['Otros Cargos', '0.00']
    data << ['Créditos', '0.00']
    data << ['Total del Período', '376.00']
    data << ['Total a Pagar', @view.number_to_currency('376.00', :unit => 'B/. ')]

    table data, :header => true, :cell_style => { :borders => [], :inline_format => true, :padding => [0, 0] } do
      row(0).size = 7
      row(0).font_style = :bold
      row(0).padding_top = 5
      row(0).padding_bottom = 3
      row(1).font_style = :bold
      row(-1).font_style = :bold
      column(0).width = 160 + 2 + 5
      column(0).padding_left = 3
      column(1).width = 150
      column(1).align = :right
      column(1).padding_right = 3
      row(-1).column(1).borders = [:top]
    end

    # Statement Detail
    bounding_box [bounds.left, cursor - 30], :width => 160, :height => 18 do
      stroke_bounds
      pad_top 4 do
        text 'DETALLE', :size => 14, :style => :bold, :align => :center
      end
    end
    stroke_horizontal_line bounds.left + 160 + 2, bounds.right, :at => cursor + 3

    ##
    # Detail table
    header = ['FECHA', 'CÓDIGO', 'DESCRIPCIÓN', 'MONTO', 'DESCUENTO', 'TOTAL']
    data = [header]
    data << ['', '', '<b>Saldo Anterior</b>', '', '', "<b>#{@view.number_to_currency('0.00', :unit => 'B/. ')}</b>"]
    statement.each do |line_item|
      data << [@view.l(line_item.received_at, :format => '%d/%m'), '', full_name(line_item.patient), '', '', '']
      line_item.lab_tests.each do |lab_test|
        data << ['', lab_test.procedure, lab_test.name, '', '', @view.number_to_currency(lab_test.prices.first.try(:amount), :unit => '')] # price must be based upon provider.price_list
      end
    end
    total = Matrix.rows(data).column(5).to_a.compact.map(&:to_d).reduce(:+)
    data << ['', '', 'Total a Pagar', '', '', @view.number_to_currency(total, :unit => 'B/. ')]

    table data, :header => true, :cell_style => { :borders => [], :inline_format => true, :padding => [0, 0] } do
      row(0).size = 7
      row(0).font_style = :bold
      row(0).padding_top = 5
      row(0).padding_bottom = 3
      row(1).font_style = :bold
      row(-1).font_style = :bold
      row(-1).border_width = 1.5
      row(-1).borders = [:top]
      column(0).width = 27
      column(0).padding_left = 3
      column(1).width = 50
      column(1).align = :center
      column(2).width = 238
      column(3).width = 75
      column(3).align = :right
      column(4).width = 75
      column(4).align = :right
      column(5).width = 75
      column(5).align = :right
      column(5).padding_right = 3
      row(1).column(2).padding_left = 3
      row(1).columns(2..5).borders = [:bottom]
      row(-1).column(2).padding_left = 3
      row(2..-2).border_width = 0.4
      row(2..-1).borders = [:bottom]
    end

    ##
    # Page number
    number_pages "#{I18n.t('results.index.page')} <page> #{I18n.t('results.index.of')} <total>", { :at => [bounds.right - 110, bounds.bottom], :size => 6 }
  end
end
