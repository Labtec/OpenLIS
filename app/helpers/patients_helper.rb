module PatientsHelper
  def options_for_gender
    [
      [ I18n.translate('patients.female'),  'F' ],
      [ I18n.translate('patients.male'),    'M' ],
      [ I18n.translate('patients.unknown'), 'U' ]
    ]
  end

  def options_for_types
    [
      [ I18n.translate('patients.canine'), 1 ],
      [ I18n.translate('patients.feline'), 2 ],
      [ I18n.translate('patients.equine'), 3 ],
      [ I18n.translate('patients.other'),  0 ]
    ]
  end
end
