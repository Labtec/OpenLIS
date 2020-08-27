$(document).on 'turbolinks:load', ->
  provinces = $('#patient_address_province').html()
  districts = $('#patient_address_district').html()
  corregimientos = $('#patient_address_corregimiento').html()
  blank_option = "<option value='' selected='selected'></option>"

  # Province
  selected_province = $(provinces).filter(':selected').html()

  if typeof(selected_province) == "undefined"
    $('#patient_address_district').empty().prop('disabled', true)
    $('#patient_address_corregimiento').empty().prop('disabled', true)
    $('#patient_address_line').prop('disabled', true)
    $('#patient_address_map').hide()
  else
    # District
    district_options = $(districts).filter("optgroup[label='#{selected_province}']").html()
    $('#patient_address_district').html(district_options).parent().show()
    selected_district = $(district_options).filter(":selected").html()

    # Handle the special case of Guna Yala
    # where there are no districts
    if selected_province == 'Guna Yala'
      $('#patient_address_district').empty().prop('disabled', true)

    # Corregimiento
    corregimiento_options = $(corregimientos).filter("optgroup[label='#{selected_district}']").html()
    $('#patient_address_corregimiento').html(corregimiento_options).parent().show()

  # Province change trigger
  $('#patient_address_province').change ->
    selected_province = $('#patient_address_province :selected').text()

    district_options = $(districts).filter("optgroup[label='#{selected_province}']").prepend(blank_option).html()
    $('#patient_address_district').prop('disabled', false).html(district_options).val('').parent().show()

    $('#patient_address_map').show()
    updateMap selected_province, '', ''

    # If the Province box is empty, empty all fields
    if selected_province == ''
      $('#patient_address_district').empty().prop('disabled', true)
      $('#patient_address_corregimiento').empty().prop('disabled', true)
      $('#patient_address_line').val('').prop('disabled', true)
      $('#patient_address_map').hide()

    # Handle the special case of Guna Yala
    # where there are no districts
    if selected_province == 'Guna Yala'
      $('#patient_address_district').empty().prop('disabled', true)
      corregimiento_options = $(corregimientos).filter("optgroup[label='Guna Yala']").prepend(blank_option).html()
      $('#patient_address_corregimiento').prop('disabled', false).html(corregimiento_options).val('').parent().show()
    else
      $('#patient_address_corregimiento').empty().prop('disabled', true)
      $('#patient_address_line').prop('disabled', true)

  # District change trigger
  $('#patient_address_district').change ->
    $('#patient_address_district option[value=""]').remove()
    selected_district = $('#patient_address_district :selected').text()

    corregimiento_options = $(corregimientos).filter("optgroup[label='#{selected_district}']").prepend(blank_option).html()
    $('#patient_address_corregimiento').prop('disabled', false).html(corregimiento_options).val('').parent().show()

    $('#patient_address_line').prop('disabled', true)

    updateMap selected_province, selected_district, ''

  # Corregimiento change trigger
  $('#patient_address_corregimiento').change ->
    $('#patient_address_corregimiento option[value=""]').remove()
    selected_corregimiento = $('#patient_address_corregimiento :selected').text()

    $('#patient_address_line').prop('disabled', false)

    # Handle the special case of Guna Yala
    # where there are no districts, so the
    # value of district is not used in the map
    if selected_province == 'Guna Yala'
      selected_district = ''

    updateMap selected_province, selected_district, selected_corregimiento

# Update map link
updateMap = (province, district, corregimiento) ->
  $('#patient_address_map').attr('href', 'https://www.google.com/maps/place/+' + corregimiento + '+' + district + '+' + province + '+Panamá')
