module AccessionsHelper
  def practitioner(doctor)
    if doctor
      concat t('.doctor')
      content_tag(:strong, doctor.name)
    else
      content_tag :strong, t('.walk_in')
    end
  end
end
