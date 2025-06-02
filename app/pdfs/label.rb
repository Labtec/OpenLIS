# frozen_string_literal: true

require "barby"
require "barby/barcode/code_128"
require "barby/outputter/prawn_outputter"

class Label < Prawn::Document
  BARCODE_HEIGHT = 28.5 # 10 mm
  BARCODE_HUMAN_HEIGHT = 6
  LABEL_HEIGHT = 72 # 1 in
  LABEL_WIDTH = 144 # 2 in
  LINE_HEIGHT = 8
  LINE_PADDING = 1
  PADDING = 5
  TEXT_SIZE = 7
  TEXT_SIZE_SMALL = 6
  TEXT_SIZE_TINY = 5

  LABEL_SIZE = [ LABEL_WIDTH, LABEL_HEIGHT ]
  PATIENT_DEMOGRAPHICS_HEIGHT = 2 * TEXT_SIZE + LINE_PADDING
  STAT_HEIGHT = LINE_HEIGHT + LINE_PADDING
  XXX_SERVICE_REQUEST_STAT = false
  XXX_SERVICE_REQUEST_STAT ? PADDING_LEFT = PADDING + STAT_HEIGHT : PADDING_LEFT = PADDING

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

  def barcode(service_request_id)
    padded_service_request_id = "%06i" % service_request_id
    accession_prefix = "199" # XXX
    accession_prefix_hyphenated = "HM1-99" # XXX https://www.hl7.org/fhir/valueset-diagnostic-service-sections.html
    accession_id = "#{accession_prefix}#{padded_service_request_id}"
    barcode = Barby::Code128.new(accession_id)
    barcode_width = barcode.encoding.size
    barcode_quiet_zone = (bounds.width - barcode_width) / 2

    bounding_box([ barcode_quiet_zone, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT ], width: barcode_width, height: BARCODE_HEIGHT + LINE_HEIGHT) do
      barcode.annotate_pdf(self, x: bounds.left, y: bounds.top - BARCODE_HEIGHT, height: BARCODE_HEIGHT)
      formatted_text_box(
        [
          { text: "#{accession_prefix_hyphenated}-#{padded_service_request_id} * #{accession_id}", font: "OCRB", size: TEXT_SIZE_TINY, overflow: :shrink_to_fit }
        ],
        at: [ bounds.left, bounds.top - BARCODE_HEIGHT - LINE_PADDING ],
        width: bounds.width,
        height: BARCODE_HUMAN_HEIGHT,
        align: :left
      )
    end
  end

  def collection_info
    bounding_box([ bounds.left, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT - BARCODE_HEIGHT - LINE_HEIGHT ], width: bounds.width, height: TEXT_SIZE_SMALL) do
      text "#{t('labels.drawn_at')}#{l(@specimen.drawn_at, format: :label).upcase}", size: TEXT_SIZE_SMALL
    end
    bounding_box([ bounds.left, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT - BARCODE_HEIGHT - LINE_HEIGHT ], width: bounds.width, height: TEXT_SIZE_SMALL) do
      text "#{t('labels.drawn_by')}#{@specimen.drawer.initials}", align: :right, size: TEXT_SIZE_SMALL
    end
  end

  def order_list
    # XXX
    text_box "CBC", at: [ bounds.left, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT - BARCODE_HEIGHT - LINE_HEIGHT - TEXT_SIZE ], width: bounds.width, height: TEXT_SIZE_TINY, size: TEXT_SIZE_TINY if @specimen.panels_list.include?("CBC")
    # overflow = text_box @specimen.tests_list.join(","), at: [ bounds.left, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT - BARCODE_HEIGHT - LINE_HEIGHT - TEXT_SIZE ], width: bounds.width, height: TEXT_SIZE_TINY, size: TEXT_SIZE_TINY, overflow: :truncate
    # text_box "+", at: [ bounds.right - TEXT_SIZE_TINY / 2, bounds.top - PATIENT_DEMOGRAPHICS_HEIGHT - BARCODE_HEIGHT - LINE_HEIGHT - TEXT_SIZE ], width: bounds.width, height: TEXT_SIZE_TINY, size: TEXT_SIZE_TINY unless overflow.empty?
  end

  def patient_demographics
    bounding_box([ bounds.left, bounds.top ], width: bounds.width, height: PATIENT_DEMOGRAPHICS_HEIGHT) do
      # Name
      bounding_box([ bounds.left, bounds.top ], width: bounds.width, height: LINE_HEIGHT) do
        formatted_text [
          { text: name_last_comma_first_mi_label(@patient), size: TEXT_SIZE, styles: [ :bold ] }
        ]
      end
      # ID
      bounding_box([ bounds.left, bounds.top - LINE_HEIGHT ], width: bounds.width, height: TEXT_SIZE) do
        text @patient.identifier
      end
      # DOB, Age, Gender
      bounding_box([ bounds.left, bounds.top - LINE_HEIGHT ], width: bounds.width, height: TEXT_SIZE) do
        text "#{l(@patient.birthdate, format: :label).upcase}  #{display_pediatric_age_label(@patient.pediatric_age)}  #{@patient.gender}", align: :right
      end
    end
  end

  def priority
    if XXX_SERVICE_REQUEST_STAT
      fill_and_stroke_rectangle [ 0 - STAT_HEIGHT - PADDING, LABEL_HEIGHT - PADDING ], STAT_HEIGHT, LABEL_HEIGHT
      bounding_box([ 0 - PADDING, 0 - PADDING + STAT_HEIGHT ], width: LABEL_HEIGHT, height: STAT_HEIGHT) do
        rotate(90, origin: [ 0, 0 ]) do
          formatted_text_box(
            [ { text: t("labels.stat"), styles: [ :bold ], color: [ 0, 0, 0, 0 ], size: TEXT_SIZE_SMALL } ],
            at: [ 0, 0 + LINE_HEIGHT - LINE_PADDING - 0.5 ],
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
