# Price List

require "prawn"
require "#{RAILS_ROOT}/app/views/shared/logo"

# Corporate colors
colors = {
  :black => [0, 0, 0, 100],
  :white => [0, 0, 0, 0],
  :gray => [0, 0, 0, 10],
  :highlight_gray => [0, 0, 0, 15],
  :logo_gray => [0, 0, 0, 75],
  :high_value => [0, 100, 100, 0],
  :low_value => [100, 100, 0, 0],
  :abnormal_value => [0, 100, 0, 50]
}

# Document defaults
font_path = "#{RAILS_ROOT}/lib/fonts/MyriadPro"
pdf.font_families["MyriadPro"] = {
  :normal      => { :file => font_path + "-Regular.ttf" },
  :italic      => { :file => font_path + "-SemiCnIt.ttf" },
  :bold        => { :file => font_path + "-Semibold.ttf" },
  :bold_italic => { :file => font_path + "-BoldSemiCnIt.ttf" }
}

file = "#{RAILS_ROOT}/lib/fonts/HelveticaWorld"
pdf.font_families["HelveticaWorld"] = {
  :normal      => { :file => file + "-Regular.ttf"},
  :italic      => { :file => file + "-Italic.ttf"},
  :bold        => { :file => file + "-Bold.ttf" },
  :bold_italic => { :file => file + "-BoldItalic.ttf" }
}

pdf.font "HelveticaWorld"
pdf.font_size = 8

top_margin = 698
left_margin = -25
table_padding = 2
form_indenting = 2
header_height = 50
name_width = 150
procedure_width = 50
price_width = 50

##
# Variables
heading_padding = 5.5
heading_indent = 20
logo_width = 150
logo_height = 50

pdf.fill_color colors[:black]
pdf.stroke_color colors[:black]


# Page Header
pdf.repeat :all do
  # Corporate logo
  pdf.translate(pdf.bounds.left, pdf.bounds.top - header_height) do
    pdf.logo
  end
  # Corporate information
  pdf.bounding_box([pdf.bounds.left + logo_width, pdf.bounds.top], :width => pdf.bounds.width - logo_width, :height => logo_height) do
    pdf.pad_top heading_padding do
      pdf.indent heading_indent do
        pdf.font("MyriadPro") do
          pdf.text "MasterLab—Laboratorio Clínico Especializado", :size => 11, :style => :bold
          pdf.text "Villa Lucre • Consultorios Médicos San Judas Tadeo • Local 107", :size => 9, :color => colors[:logo_gray]
          pdf.text "Tel: 222-9200 ext. 1107 • Fax: 277-7832 • Email: masterlab@labtecsa.com", :size => 9, :color => colors[:logo_gray]
          pdf.text "Director: Lcdo. Erick Chu, TM, MSc", :size => 9, :color => colors[:logo_gray]
        end
      end
    end
  end

  pdf.move_down 25
  pdf.text "Lista de Precios", :align => :center, :size => 10, :style => :bold
  pdf.move_down 5

  # Manually add second column title or fix bug in prawn
end

pdf.column_box [0, pdf.cursor], :width => pdf.bounds.width, :columns => 2 do

# Prices Table
prices_table = [["Prueba", "CPT", "Precio"]]
@prices.map do |price|
  prices_table += [[
    price.priceable.name,
    price.priceable.procedure,
    number_to_currency(price.amount)
  ]]
end

pdf.table prices_table,
  :header => true,
  # :position => :center, # This breaks the column layout
  :column_widths => { 0 => name_width, 1 => procedure_width, 2 => price_width },
  :row_colors => [colors[:white], colors[:gray]],
  :cell_style => { :inline_format => true } do |t|
    t.cells.borders = []
    t.column(0).style :align => :left
    t.column(1).style :align => :center
    t.column(2).style :align => :right
    t.before_rendering_page do |page|
      page.row(0).border_top_color = colors[:black]
      page.row(0).border_top_width = 1
      page.row(0).border_bottom_color = colors[:black]
      page.row(0).border_bottom_width = 0.5
      page.row(0).borders = [:top, :bottom]
      page.row(0).font_style = :bold
      page.row(-1).border_bottom_color = colors[:black]
      page.row(-1).border_bottom_width = 1
      page.row(-1).borders = [:bottom]
    end
  end
end