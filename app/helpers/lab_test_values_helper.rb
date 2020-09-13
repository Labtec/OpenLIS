# frozen_string_literal: true

module LabTestValuesHelper
  def options_for_flag
    [
      ['Normality',
        [
          ['Abnormal', 'A'],
          ['High', 'H'],
          ['Low', 'L'],
          ['Normal', 'N'],
          ['Critical abnormal', 'AA'],
          ['Critical high', 'HH'],
          ['Critical low', 'LL']
        ]
      ],
      ['Susceptibility',
        [
          ['Intermediate', 'I'],
          ['Non-susceptible', 'NS'],
          ['Resistant', 'R'],
          ['Susceptible', 'S']
        ]
      ],
      ['Detection',
        [
          ['Indeterminate', 'IND'],
          ['Equivocal', 'E'],
          ['Negative', 'NEG'],
          ['Not detected', 'ND'],
          ['Positive', 'POS'],
          ['Detected', 'DET']
        ]
      ],
      ['Reactivity',
        [
          ['Non-reactive', 'NR'],
          ['Reactive', 'R'],
          ['Weakly reactive', 'WR']
        ]
      ]
    ]
  end

  def snomed_hyperlink(snomed)
    link_to snomed, "https://browser.ihtsdotools.org/?perspective=full&conceptId1=#{snomed}&edition=MAIN/SNOMEDCT-ES/2020-04-30&release=&languages=es,en", target: :_blank, rel: :noopener if snomed.present?
  end
end
