Date::DATE_FORMATS[:mmddccyy] = "%m/%d/%Y"
Date::DATE_FORMATS[:mmddyy] = "%m/%d/%y"
Time::DATE_FORMATS[:w3cdtf] = ->(time) { time.strftime("%Y-%m-%dT%H:%M:%S#{time.formatted_offset}") }
