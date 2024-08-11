# frozen_string_literal: true

module LabTestValuesHelper
  def options_for_flag
    [
      [ "Exceptions",
        [
          [ "Off scale low", "<" ],
          [ "Off scale high", ">" ],
          [ "Insufficient evidence", "IE" ]
        ]
      ],
      [ "Normality",
        [
          [ "Abnormal", "A" ],
          [ "High", "H" ],
          [ "Low", "L" ],
          [ "Normal", "N" ],
          [ "Significantly high", "HU" ],
          [ "Significantly low", "LU" ],
          [ "Critical abnormal", "AA" ],
          [ "Critical high", "HH" ],
          [ "Critical low", "LL" ]
        ]
      ],
      [ "Susceptibility",
        [
          [ "Intermediate", "I" ],
          [ "Non-susceptible", "NS" ],
          [ "Resistant", "R" ],
          [ "Susceptible", "S" ]
        ]
      ],
      [ "Detection",
        [
          [ "Indeterminate", "IND" ],
          [ "Equivocal", "E" ],
          [ "Negative", "NEG" ],
          [ "Not detected", "ND" ],
          [ "Positive", "POS" ],
          [ "Detected", "DET" ]
        ]
      ],
      [ "Expectation",
        [
          [ "Expected", "EXP" ],
          [ "Unexpected", "UNE" ]
        ]
      ],
      [ "Reactivity",
        [
          [ "Non-reactive", "NR" ],
          [ "Reactive", "RR" ],
          [ "Weakly reactive", "WR" ]
        ]
      ]
    ]
  end

  def loinc_answer_hyperlink(loinc_answer)
    if loinc_answer.present?
      link_to loinc_answer, "https://loinc.org/#{loinc_answer}", target: :_blank, rel: :noopener
    end
  end

  def snomed_hyperlink(snomed)
    link_to snomed, "https://browser.ihtsdotools.org/?perspective=full&conceptId1=#{snomed}&edition=MAIN/SNOMEDCT-ES/2020-04-30&release=&languages=es,en", target: :_blank, rel: :noopener if snomed.present?
  end
end
