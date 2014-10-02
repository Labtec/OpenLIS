module AccessionsHelper
  def doctor_name(doctor)
    if doctor
      t('.doctor')
      content_tag :strong, doctor.name
    else
      content_tag :strong, t('.walk_in')
    end
  end
end
