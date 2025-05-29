# frozen_string_literal: true

require "barby"
require "barby/barcode/code_128"
require "barby/barcode/data_matrix"
require "barby/outputter/prawn_outputter"

class Label < Prawn::Document
  BARCODE_WIDTH_MULTIPLIER = 16
  BARCODE_DM_WIDTH_MULTIPLIER = 6
  LABEL_WIDTH = 144 # 2 in
  LABEL_HEIGHT = 72 # 1 in
  LABEL_SIZE = [ LABEL_WIDTH, LABEL_HEIGHT ]
  LINE_PADDING = 2
  TEXT_SIZE_SMALL = 5
  TEXT_SIZE = 6
  TEXT_SIZE_BIG = 8
  LINE_HEIGHT_SMALL = 5
  LINE_HEIGHT = 8
  LINE_HEIGHT_BIG = 10
  NORMAL_RULE_WIDTH = 1
  PADDING = 5
  PATIENT_DEMOGRAPHICS_HEIGHT = 24

  BARCODE_HEIGHT = 5 * TEXT_SIZE
  QUIET_ZONE = PADDING * 2

  def initialize(patient, specimen, view_context)
    @patient = patient
    @specimen = specimen
    @view = view_context

    super(
      info: {
        Title: "#{specimen.id}",
        Author: "MasterLab",
        Creator: "MasterLab",
        Producer: "MasterLab",
        CreationDate: @specimen.drawn_at,
        ModDate: @specimen.drawn_at
      },
      page_size: LABEL_SIZE,
      inline: true,
      top_margin: PADDING,
      right_margin: PADDING,
      bottom_margin: PADDING,
      left_margin: QUIET_ZONE,
      compress: true,
      optimize_objects: true,
      enable_pdfa_1b: true,
      print_scaling: :none
    )

    file = File.expand_path("fonts/OCR-B", __dir__)
    font_families["OCRB"] = {
      normal: { file: "#{file}.ttf" }
    }

    file = File.expand_path("fonts/HelveticaWorld", __dir__)
    font_families["HelveticaWorld"] = {
      normal: { file: "#{file}-Regular.ttf" },
      italic: { file: "#{file}-Italic.ttf" },
      bold: { file: "#{file}-Bold.ttf" },
      bold_italic: { file: "#{file}-BoldItalic.ttf" }
    }

    font "HelveticaWorld", size: TEXT_SIZE

    ##
    # Variables
    page.margins[:top]
    bottom_margin = page.margins[:bottom]
    bounds.top
    page_bottom = bounds.bottom - bottom_margin

    ##
    # Label
    first_row
    patient_demographics
    barcode(@specimen.id.to_s)
    performer
    order_list
  end

  private

  def accession_id
    bounding_box([ bounds.left + bounds.width / 4, bounds.top ], width: bounds.width / 4, height: LINE_HEIGHT) do
      text @specimen.id.to_s, align: :center, size: TEXT_SIZE_SMALL
    end
  end

  def barcode(accession_id)
    barcode = Barby::Code128.new(accession_id)
    barcode_dm = Barby::DataMatrix.new(accession_id)
    barcode_width = BARCODE_WIDTH_MULTIPLIER * accession_id.size # XXX
    barcode_dm_width = BARCODE_DM_WIDTH_MULTIPLIER * accession_id.size # XXX

    bounding_box([ bounds.left, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT ], width: barcode_width, height: BARCODE_HEIGHT) do
      barcode.annotate_pdf(self, x: bounds.left, y: bounds.top - BARCODE_HEIGHT, height: BARCODE_HEIGHT)
    end
    bounding_box([ bounds.left + barcode_width + QUIET_ZONE, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT ], width: barcode_dm_width, height: BARCODE_HEIGHT) do
      barcode_dm.annotate_pdf(self, x: bounds.left, y: bounds.top - BARCODE_HEIGHT, height: BARCODE_HEIGHT)
    end
  end

  def collected_at
    collected_at_width = 20

    bounding_box([ bounds.right - bounds.width / 2, bounds.top ], width: bounds.width / 2, height: LINE_HEIGHT) do
      text l(@specimen.drawn_at, format: :label), align: :right, size: TEXT_SIZE_SMALL
    end
  end

  def first_row
    priority
    accession_id
    collected_at
  end

  def order_list
    text_box @specimen.tests_list.join(", "), at: [ bounds.left, cursor - PADDING ], width: bounds.width, height: TEXT_SIZE, overflow: :shrink_to_fit # XXX
  end

  def patient_demographics
    bounding_box([ bounds.left, cursor ], width: bounds.width, height: PATIENT_DEMOGRAPHICS_HEIGHT) do
      bounding_box([ bounds.left, bounds.top ], width: bounds.width, height: TEXT_SIZE_BIG) do
        text name_last_comma_first_mi(@patient).upcase, style: :bold, size: TEXT_SIZE_BIG
      end
      bounding_box([ bounds.left, bounds.top - TEXT_SIZE_BIG ], width: bounds.width / 2, height: TEXT_SIZE) do
        text @patient.identifier
      end
      bounding_box([ bounds.right - bounds.width / 2, bounds.top - TEXT_SIZE_BIG ], width: bounds.width / 2, height: TEXT_SIZE) do
        text "DOB: #{l(@patient.birthdate, format: :label)}", align: :right
      end
      bounding_box([ bounds.right - bounds.width / 2, bounds.top - TEXT_SIZE_BIG - TEXT_SIZE ], width: bounds.width / 2, height: TEXT_SIZE) do
        text "#{display_pediatric_age_label(@patient.pediatric_age)} #{@patient.gender}", align: :right
      end
    end
  end

  def performer
    bounding_box([ bounds.right - bounds.width / 2, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT - 4 * TEXT_SIZE ], width: bounds.width / 2, height: TEXT_SIZE) do
      text @specimen.drawer.initials, align: :right, size: TEXT_SIZE_SMALL
    end
  end

  def priority
    bounding_box([ bounds.left, bounds.top ], width: TEXT_SIZE * 3, height: LINE_HEIGHT) do
      # case @service_request.priority
      # when "routine"
        text "ROUT", style: :bold
      # when "urgent"
      #   text "URGNT", style: :bold
      # when "asap"
      #   text "ASAP", style: :bold
      # when "stat"
      #   fill_and_stroke_rectangle [ bounds.left, bounds.top ], TEXT_SIZE * 3, TEXT_SIZE
      #   pad_top 0.75 do
      #     text "STAT", style: :bold, align: :center, color: [0, 0, 0, 0]
      #   end
      # end
    end
  end

  def method_missing(...)
    @view.send(...)
  end
end
