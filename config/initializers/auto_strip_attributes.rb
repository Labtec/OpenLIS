AutoStripAttributes::Config.setup do
  set_filter(convert_all_whitespace: false) do |value|
    if value.respond_to?(:gsub)
      value.gsub("\u0009", " ") # HORIZONTAL TAB
           .gsub("\u000A", " ") # LINE FEED OR NEW LINE
           .gsub("\u000B", " ") # VERTICAL TAB
           .gsub("\u000C", " ") # FORMFEED
           .gsub("\u000D", " ") # CARRIAGE RETURN
           .gsub("\u0020", " ") # SPACE
           .gsub("\u0085", " ") # NEXT LINE
           .gsub("\u00A0", " ") # NO-BREAK SPACE
           .gsub("\u180E", " ") # MONGOLIAN VOWEL SEPARATOR
           .gsub("\u2000", " ") # EN QUAD
           .gsub("\u2001", " ") # EM QUAD
           .gsub("\u2002", " ") # EN SPACE
           .gsub("\u2003", " ") # EM SPACE
           .gsub("\u2004", " ") # THREE-PER-EM SPACE
           .gsub("\u2005", " ") # FOUR-PER-EM SPACE
           .gsub("\u2006", " ") # SIX-PER-EM SPACE
           .gsub("\u2007", " ") # FIGURE SPACE
           .gsub("\u2008", " ") # PUNCTUATION SPACE
           .gsub("\u2009", " ") # THIN SPACE
           .gsub("\u200A", " ") # HAIR SPACE
           .gsub("\u200B", " ") # ZERO WIDTH SPACE
           .gsub("\u2028", " ") # LINE SEPARATOR
           .gsub("\u2029", " ") # PARAGRAPH SEPARATOR
           .gsub("\u202F", " ") # NARROW NO-BRREAK SPACE
           .gsub("\u205F", " ") # MEDIUM MATHEMATICAL SPACE
           .gsub("\u2060", " ") # WORD JOINER
           .gsub("\u3000", " ") # IDEOGRAPHIC SPACE
           .gsub("\uFEFF", " ") # ZERO WIDTH NON-BREAKING SPACE
    else
      value
    end
  end

  filters_order.insert(0, :convert_all_whitespace)
  filters_enabled[:convert_all_whitespace] = true
  filters_enabled[:squish] = true
end
