# encoding: utf-8

require "prawn"
require "#{RAILS_ROOT}/app/views/shared/logo"

##
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

##
# Document fonts
file = "#{RAILS_ROOT}/lib/fonts/MyriadPro"
pdf.font_families["MyriadPro"] = {
  :normal      => { :file => file + "-Regular.ttf" },
  :italic      => { :file => file + "-SemiCnIt.ttf" },
  :bold        => { :file => file + "-Semibold.ttf" },
  :bold_italic => { :file => file + "-BoldSemiCnIt.ttf" }
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

pdf.fill_color colors[:black]
pdf.stroke_color colors[:black]

##
# Constants
half_inch = 36
one_inch = half_inch * 2
min_hp_print = 17
safe_print = half_inch
fold = pdf.page.dimensions[3] / 3
top_margin = pdf.page.margins[:top]
right_margin = pdf.page.margins[:right]
bottom_margin = pdf.page.margins[:bottom]
left_margin = pdf.page.margins[:left]
page_top = pdf.bounds.top + top_margin
page_bottom = pdf.bounds.bottom - bottom_margin
page_left = pdf.bounds.left - left_margin

##
# Variables
line_padding = 2
row_vertical_padding = 1
line_height = pdf.font_size + line_padding
row_height = pdf.font_size + 4
title_row_height = line_height * 1.5
page_number_height = pdf.font_size - 0.25
notes_padding = 7
notes_indent = 45
number_of_rows = 600 / row_height
padding = 5
footer_margin_bottom = half_inch
heading_padding = 5.5
heading_indent = 20
footer_height = line_height * 3 + padding
logo_width = 150
logo_height = 50
flash_tag_width = 80
demographics_width_1 = 45
demographics_width_2 = 155
demographics_width_3 = 30
demographics_width_4 = 80
demographics_width_5 = 80
demographics_width_6 = 150
column_0_width = 140
column_1_width = 80
column_2_width = 88
column_3_width = 40
column_range_width = 192
column_6_padding_right = 40
column_description_range_width = 70
column_5_width = pdf.font_size - 2
column_4_width = (column_range_width - column_description_range_width - column_5_width - column_6_padding_right) / 2
column_6_width = column_4_width + column_6_padding_right
table_padding = 2
signature_spacing = line_height * 3
signature_line = 180
patient_demographics_height = row_height * 3
window_height = 36 * 2.25
window_width = 36 * 9
envelope_adjustment_height = 34
header_height = logo_height + envelope_adjustment_height + patient_demographics_height + title_row_height + padding * 2.5
signature_block_height = signature_spacing + line_height * 3 + padding
demographics_stop_1 = demographics_width_1
demographics_stop_2 = demographics_stop_1 + demographics_width_2
demographics_stop_3 = demographics_stop_2 + demographics_width_3
demographics_stop_4 = demographics_stop_3 + demographics_width_4
demographics_stop_5 = demographics_stop_4 + demographics_width_5
title_row_stop_1 = column_0_width
title_row_stop_2 = title_row_stop_1 + column_1_width
title_row_stop_3 = title_row_stop_2 + column_2_width
title_row_stop_4 = title_row_stop_3 + column_3_width
pdf.page.margins[:top] = header_height + top_margin

##
# Folding marks and window (do not print)
# pdf.horizontal_line page_left, page_left + min_hp_print, :at => page_top - fold
# pdf.horizontal_line page_left, page_left + min_hp_print, :at => page_top - 2 * fold
# pdf.rounded_rectangle [page_left + half_inch / 2, page_top - fold + one_inch + window_height], window_width, window_height, 10

##
# Header
pdf.repeat :all do
  ##
  # Flash tag top
  pdf.bounding_box([pdf.bounds.right - flash_tag_width, page_top - half_inch - line_height], :width => flash_tag_width, :height => line_height) do
    pdf.text "#{t('.preliminary') unless @accession.reported_at}", :align => :right, :color => colors[:high_value]
  end

  ##
  # Letterhead
  pdf.bounding_box([pdf.bounds.left, page_top - top_margin], :width => pdf.bounds.width, :height => header_height) do
    ##
    # Corporate logo
    pdf.translate(pdf.bounds.left, pdf.bounds.top - logo_height) do
      pdf.logo
    end

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

    pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - logo_height], :width => pdf.bounds.width, :height => envelope_adjustment_height) do
    end

    pdf.stroke_horizontal_rule

    ##
    # Patient demographics
    pdf.bounding_box([pdf.bounds.left, pdf.cursor - padding * 2], :width => pdf.bounds.width, :height => patient_demographics_height) do
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => demographics_width_1, :height => row_height) do
        pdf.indent padding do
          pdf.text t('.full_name'), :style => :bold
        end
      end
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - row_height], :width => demographics_width_1, :height => row_height) do
        pdf.indent padding do
          pdf.text t('.identifier')
        end
      end
      if @accession.doctor
        pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 2 * row_height], :width => demographics_width_1, :height => row_height) do
          pdf.indent padding do
            pdf.text t('.doctor')
          end
        end
      else
        pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 2 * row_height], :width => demographics_width_1 + demographics_width_2, :height => row_height) do
          pdf.indent padding do
            pdf.text t('.walk_in')
          end
        end
      end
      pdf.bounding_box([demographics_stop_1, pdf.bounds.top], :width => demographics_width_2 + demographics_width_3 + demographics_width_4, :height => row_height) do
        pdf.text @accession.patient.full_name, :style => :bold
      end
      pdf.bounding_box([demographics_stop_1, pdf.bounds.top - row_height], :width => demographics_width_2, :height => row_height) do
        pdf.text @accession.patient.identifier
      end
      pdf.bounding_box([demographics_stop_1, pdf.bounds.top - 2 * row_height], :width => demographics_width_2, :height => row_height) do
        pdf.text @accession.doctor_name if @accession.doctor
      end

      ########################

      if @accession.patient.animal_type
        pdf.bounding_box([demographics_stop_2, pdf.bounds.top], :width => demographics_width_3, :height => row_height) do
          pdf.text t('.type'), :style => :bold
        end
      end
      pdf.bounding_box([demographics_stop_2, pdf.bounds.top - row_height], :width => demographics_width_3, :height => row_height) do
        pdf.text t('.age')
      end
      pdf.bounding_box([demographics_stop_2, pdf.bounds.top - 2 * row_height], :width => demographics_width_3, :height => row_height) do
        pdf.text t('.gender')
      end
      if @accession.patient.animal_type
        pdf.bounding_box([demographics_stop_3, pdf.bounds.top], :width => demographics_width_4, :height => row_height) do
          pdf.text @accession.patient.animal_type_name, :style => :bold
        end
      end
      pdf.bounding_box([demographics_stop_3, pdf.bounds.top - row_height], :width => demographics_width_4, :height => row_height) do
        pdf.text patient_age_at @accession
      end
      pdf.bounding_box([demographics_stop_3, pdf.bounds.top - 2 * row_height], :width => demographics_width_4, :height => row_height) do
        pdf.text @accession.patient.gender_name
      end

      ########################

      pdf.bounding_box([demographics_stop_4, pdf.bounds.top], :width => demographics_width_5, :height => row_height) do
        pdf.text t('.accession'), :style => :bold
      end
      pdf.bounding_box([demographics_stop_4, pdf.bounds.top - row_height], :width => demographics_width_5, :height => row_height) do
        pdf.text t('.drawn_at')
      end
      pdf.bounding_box([demographics_stop_4, pdf.bounds.top - 2 * row_height], :width => demographics_width_5, :height => row_height) do
        pdf.text t('.received_at')
      end
      pdf.bounding_box([demographics_stop_5, pdf.bounds.top], :width => demographics_width_6, :height => row_height) do
        pdf.text @accession.id.to_s, :style => :bold
      end
      pdf.bounding_box([demographics_stop_5, pdf.bounds.top - row_height], :width => demographics_width_6, :height => row_height) do
        pdf.text @accession.drawn_at.strftime('%e/%m/%Y %l:%M%p')
      end
      pdf.bounding_box([demographics_stop_5, pdf.bounds.top - 2 * row_height], :width => demographics_width_6, :height => row_height) do
        pdf.text "#{@accession.received_at.strftime('%e/%m/%Y %l:%M%p') if @accession.received_at}"
      end
    end

    ##
    # Report Header
    pdf.fill_color colors[:gray]
    pdf.fill_and_stroke do
      pdf.rectangle [pdf.bounds.left, pdf.bounds.bottom + title_row_height], pdf.bounds.width, title_row_height
    end
    pdf.fill_color colors[:black]

    pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom + title_row_height], :width => pdf.bounds.width, :height => title_row_height) do
      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => column_0_width, :height => title_row_height) do
        pdf.pad_top padding do
          pdf.indent padding do
            pdf.text t('.lab_test'), :style => :bold, :align => :left
          end
        end
      end
      pdf.bounding_box([title_row_stop_1, pdf.bounds.top], :width => column_1_width, :height => title_row_height) do
        pdf.pad_top padding do
          pdf.indent 0, padding do
            pdf.text t('.result'), :style => :bold, :align => :right
          end
        end
      end
      pdf.bounding_box([title_row_stop_2, pdf.bounds.top], :width => column_2_width, :height => title_row_height) do
        pdf.pad_top padding do
          pdf.indent padding do
            pdf.text t('.units'), :style => :bold, :align => :left
          end
        end
      end
      pdf.bounding_box([title_row_stop_3, pdf.bounds.top], :width => column_3_width, :height => title_row_height) do
        pdf.pad_top padding do
          pdf.text t('.flag'), :style => :bold, :align => :center
        end
      end
      pdf.bounding_box([title_row_stop_4 + column_description_range_width / 2, pdf.bounds.top], :width => column_range_width - column_description_range_width / 2, :height => title_row_height) do
        pdf.pad_top padding do
          pdf.text t('.range'), :color => colors[:white], :style => :bold, :align => :center
        end
      end
      pdf.bounding_box([title_row_stop_4 + column_description_range_width / 2, pdf.bounds.top], :width => column_range_width - column_description_range_width / 2, :height => title_row_height) do
        pdf.pad_top padding do
          pdf.text t('.range'), :color => colors[:abnormal_value], :style => :bold, :align => :center
        end
      end
    end
  end
end

##
# Begin report

##
# Results table
@results.each do |department, results|
  department_title = pdf.make_cell :content => department.name, :borders => [], :font_style => :bold, :padding => [padding, 0]
  blank_fill = pdf.make_cell :content => nil, :borders => []
  run_by = pdf.make_cell :content => "#{[t('.run_by'), @accession.reporter.initials, t('.on_date'), @accession.reported_at.strftime('%e/%m/%Y %l:%M%p')].join(' ') if @accession.reported_at}", :font_style => :italic, :size => 7.5, :borders => [], :align => :right
  data = [[department_title, blank_fill, blank_fill, blank_fill, run_by]]
  results.each do |result|
    if result.flag.present?
      cell_col_0 = pdf.make_cell :content => result.lab_test.name, :background_color => colors[:highlight_gray] ,:inline_format => true
      cell_col_1 = pdf.make_cell :content => result.formatted_value.gsub(/</, "&lt; ").gsub(/&lt; i/, "<i").gsub(/&lt; s/, "<s").gsub(/&lt; \//, "</"), :background_color => colors[:highlight_gray], :inline_format => true
    else
      cell_col_0 = pdf.make_cell :content => result.lab_test.name, :inline_format => true
      cell_col_1 = pdf.make_cell :content => result.formatted_value.gsub(/</, "&lt; ").gsub(/&lt; i/, "<i").gsub(/&lt; s/, "<s").gsub(/&lt; \//, "</"), :inline_format => true
    end
    cell_col_3 = pdf.make_cell :content => flag_name(result), :font_style => :bold, :text_color => colors[flag_color(result).to_sym]
    ##
    # Ranges sub-table
    cell_col_4 = pdf.make_table(result.ranges, :cell_style => { :padding => [0, 0.4], :borders => [] }) do
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
    data << [cell_col_0, cell_col_1, result.units, cell_col_3, cell_col_4]
  end

  pdf.table(data, :header => true, :cell_style => { :padding => [line_padding, 0] }) do
    column(0).width = column_0_width
    column(1).width = column_1_width
    column(2).width = column_2_width
    column(3).width = column_3_width
    column(4).width = column_range_width
    rows(1..-1).columns(0..3).padding = [row_vertical_padding, padding]
    rows(1..-1).columns(4..6).padding = [row_vertical_padding, 0]
    row(1..-1).column(1).align = :right
    row(1..-1).column(3).align = :center
    row(1..-1).column(0).padding_left = 5
    row(1..-1).border_bottom_color = colors[:gray]
    row(1..-1).borders = [:bottom]
    row(1..-1).border_width = 0.75
  end

  if @accession.notes.find_by_department_id(department).try(:content).present?
    pdf.pad notes_padding do
      pdf.indent notes_indent do
        pdf.text "#{t('.notes')} #{@accession.notes.find_by_department_id(department).content}", :color => colors[:abnormal_value], :style => :bold_italic, :inline_format => true
      end
    end
  end
end

##
# End of report
pdf.horizontal_rule

##
# Signature block
if pdf.cursor > pdf.bounds.bottom + signature_block_height
  pdf.move_down signature_spacing
  pdf.bounding_box([pdf.bounds.left, pdf.cursor], :width => pdf.bounds.width / 2, :height => line_height) do
    pdf.pad_top line_padding do
      pdf.text t('.reviewed_by'), :align => :right
    end
  end
  pdf.bounding_box([pdf.bounds.width / 2 + line_padding, pdf.cursor], :width => signature_line, :height => 2 * line_height + padding) do
    pdf.stroke_horizontal_rule
    pdf.pad_top padding do
      pdf.text current_user.name_to_display, :align => :center
    end
    pdf.text registration_number, :align => :center
  end
else
  pdf.bounding_box([pdf.bounds.left, pdf.bounds.bottom - line_height * 2 - padding], :width => column_0_width, :height => line_height) do
    pdf.pad_top line_padding do
      pdf.text t('.reviewed_by'), :align => :right
    end
  end
  pdf.bounding_box([column_0_width + line_padding, pdf.cursor], :width => signature_line, :height => line_height + padding) do
    pdf.stroke_horizontal_rule
    pdf.pad_top padding do
      pdf.text current_user.name_to_display + registration_number(:inline => true), :align => :center
    end
  end
end

##
# Footer
pdf.repeat :all do
  pdf.bounding_box([pdf.bounds.left, page_bottom + footer_height + footer_margin_bottom], :width => pdf.bounds.width, :height => footer_height) do
    pdf.stroke_horizontal_rule
    pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width / 2, :height => footer_height) do
      pdf.pad_top padding do
        pdf.text "#{t('.reported_at')} #{@accession.reported_at.strftime('%e/%m/%Y %l:%M%p') if @accession.reported_at}#{t('.preliminary') unless @accession.reported_at}"
        pdf.text "#{t('.printed_at')} #{Time.zone.now.strftime('%e/%m/%Y %l:%M%p')}"
      end
    end
    pdf.bounding_box([pdf.bounds.width / 2, pdf.bounds.top], :width => pdf.bounds.width / 2, :height => footer_height) do
      pdf.pad_top padding do
        pdf.text "#{t('.accession')} #{@accession.id}", :align => :right
        pdf.text "#{t('.results_of')} #{@accession.patient.full_name}", :align => :right
        pdf.text "#{t('.preliminary') unless @accession.reported_at}", :align => :right, :color => colors[:high_value]
      end
    end
  end
end

##
# Page number
pdf.number_pages "#{t('.page')} <page> #{t('.of')} <total>", { :at => [pdf.bounds.left, page_bottom + footer_margin_bottom + page_number_height] }
