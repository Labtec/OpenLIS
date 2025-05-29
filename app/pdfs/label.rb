# frozen_string_literal: true

require "barby"
require "barby/barcode/code_128"
require "barby/outputter/prawn_outputter"

class Label < Prawn::Document
  BARCODE_WIDTH_MULTIPLIER = 16
  LABEL_WIDTH = 144 # 2 in
  LABEL_HEIGHT = 72 # 1 in
  LABEL_SIZE = [ LABEL_WIDTH, LABEL_HEIGHT ]
  LINE_PADDING = 2
  TEXT_SIZE_SMALL = 5
  TEXT_HEIGHT_SMALL = 3.5
  TEXT_SIZE = 6
  TEXT_SIZE_LARGE = 7
  LINE_HEIGHT = 8
  NORMAL_RULE_WIDTH = 1
  PADDING = 5
  PATIENT_DEMOGRAPHICS_HEIGHT = 16
  QUIET_ZONE = 10

  BARCODE_HEIGHT = 4 * TEXT_SIZE
  XXX_SERVICE_REQUEST_STAT = false
  XXX_SERVICE_REQUEST_STAT ? PADDING_LEFT = PADDING + LINE_HEIGHT + LINE_PADDING : PADDING_LEFT = PADDING

  def initialize(patient, specimen, view_context)
    @patient = patient
    @specimen = specimen
    @view = view_context

    super(
      info: {
        Title: specimen.id.to_s,
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
      left_margin: PADDING_LEFT,
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
    # Label
    priority
    patient_demographics
    barcode(@specimen.id.to_s)
    collection_info
    order_list
  end

  private

  def barcode(accession_id)
    barcode = Barby::Code128.new(accession_id)
    barcode_width = barcode.encoding.size

    bounding_box([ bounds.left - PADDING * 2 + barcode_width / 2, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT ], width: barcode_width, height: BARCODE_HEIGHT + LINE_HEIGHT) do
      barcode.annotate_pdf(self, x: bounds.left, y: bounds.top - BARCODE_HEIGHT, height: BARCODE_HEIGHT)
      formatted_text_box(
        [
          { text: @specimen.id.to_s, font: "OCRB", size: TEXT_SIZE_SMALL, overflow: :shrink_to_fit }
        ],
        at: [ bounds.left, bounds.top - BARCODE_HEIGHT - LINE_PADDING ],
        width: bounds.width,
        height: LINE_HEIGHT,
        align: :center
      )
    end
  end

  def order_list
    text_box @specimen.tests_list.join(", "), at: [ bounds.left, cursor ], width: bounds.width, height: LINE_HEIGHT, overflow: :shrink_to_fit # XXX
  end

  def patient_demographics
    bounding_box([ bounds.left, bounds.top ], width: bounds.width, height: PATIENT_DEMOGRAPHICS_HEIGHT) do
      bounding_box([ bounds.left, bounds.top ], width: bounds.width, height: TEXT_SIZE) do
        text name_last_comma_first_mi(@patient)
      end
      bounding_box([ bounds.left, bounds.top - LINE_HEIGHT ], width: bounds.width / 2, height: LINE_HEIGHT) do
        text @patient.identifier
      end
      bounding_box([ bounds.right - bounds.width / 2 - 10, bounds.top - LINE_HEIGHT ], width: bounds.width / 2 + 10, height: LINE_HEIGHT) do
        text "#{l(@patient.birthdate, format: :label).upcase}   #{display_pediatric_age_label(@patient.pediatric_age)} #{@patient.gender}", align: :right
      end
    end
  end

  def collection_info
    bounding_box([ bounds.left, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT - BARCODE_HEIGHT - LINE_HEIGHT ], width: bounds.width, height: LINE_HEIGHT) do
      text "Col: #{l(@specimen.drawn_at, format: :label).upcase}", size: TEXT_SIZE_SMALL
    end
    bounding_box([ bounds.left, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT - BARCODE_HEIGHT - LINE_HEIGHT ], width: bounds.width, height: LINE_HEIGHT) do
      text "by: #{@specimen.drawer.initials}", size: TEXT_SIZE_SMALL, align: :right
    end
  end

  def priority
    if XXX_SERVICE_REQUEST_STAT
      fill_and_stroke_rectangle [ 0 - LINE_HEIGHT - PADDING - LINE_PADDING, LABEL_HEIGHT - PADDING ], LINE_HEIGHT + LINE_PADDING, LABEL_HEIGHT
      bounding_box([ 0 - PADDING, 0 - PADDING + LINE_HEIGHT + LINE_PADDING ], width: LABEL_HEIGHT, height: LINE_HEIGHT + LINE_PADDING) do
        rotate(90, origin: [ 0, 0 ]) do
          formatted_text_box(
            [ { text: "STAT", styles: [ :bold ], color: [ 0, 0, 0, 0 ], size: TEXT_SIZE_LARGE } ],
            at: [ 0, 0 + LINE_HEIGHT - LINE_PADDING / 2 ],
            width: LABEL_HEIGHT,
            height: LINE_HEIGHT,
            align: :center
          )
        end
      end
    end
  end

  def method_missing(...)
    @view.send(...)
  end
end
