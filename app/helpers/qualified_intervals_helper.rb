# frozen_string_literal: true

module QualifiedIntervalsHelper
  def range_symbol(range)
    if range.begin && range.end
      '–'
    elsif range.begin
      '≥'
    elsif range.end
      range.exclude_end? ? '<' : '≤'
    end
  end

  def format_range(range, decimal_precision: 0)
    return unless range

    range_begin = range.begin.is_a?(ActiveSupport::Duration) ? range.begin.iso8601[1..] : number_with_precision(range.begin, precision: decimal_precision.to_i, delimiter: ',')
    range_end = range.end.is_a?(ActiveSupport::Duration) ? range.end.iso8601[1..] : number_with_precision(range.end, precision: decimal_precision.to_i, delimiter: ',')

    if range_begin && range_end
      "#{range_begin}#{range_symbol(range)}#{range_end}"
    elsif range_begin
      "#{range_symbol(range)}#{range_begin}"
    elsif range_end
      "#{range_symbol(range)}#{range_end}"
    end
  end

  def options_for_context
    [
      ['Type',
        [
          ['Normal Range', 'normal'],
          ['Recommended Range', 'recommended'],
          ['Treatment Range', 'treatment'],
          ['Therapeutic Desired Level', 'therapeutic'],
          ['Pre Therapeutic Desired Level', 'pre'],
          ['Post Therapeutic Desired Level', 'post']
        ]
      ],
      ['Endocrine',
        [
          ['Pre-Puberty', 'pre-puberty'],
          ['Follicular Stage', 'follicular'],
          ['MidCycle', 'midcycle'],
          ['Luteal', 'luteal'],
          ['Post-Menopause', 'postmenopausal']
        ]
      ]
    ]
  end
end
