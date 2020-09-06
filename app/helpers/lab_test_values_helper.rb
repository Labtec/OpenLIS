module LabTestValuesHelper
  def snomed_hyperlink(snomed)
    link_to snomed, "https://browser.ihtsdotools.org/?perspective=full&conceptId1=#{snomed}&edition=MAIN/SNOMEDCT-ES/2020-04-30&release=&languages=es,en", target: :_blank, rel: :noopener if snomed.present?
  end
end
