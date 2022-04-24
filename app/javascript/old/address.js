$(document).on('turbo:load turbo:render', function() {
  var blank_option, corregimiento_options, corregimientos, district_options, districts, provinces, selected_district, selected_province;
  provinces = $('#patient_address_province').html();
  districts = $('#patient_address_district').html();
  corregimientos = $('#patient_address_corregimiento').html();
  blank_option = "<option value='' selected='selected'></option>";
  selected_province = $(provinces).filter(':selected').html();
  if (typeof selected_province === "undefined") {
    $('#patient_address_district').empty().prop('disabled', true);
    $('#patient_address_corregimiento').empty().prop('disabled', true);
    $('#patient_address_line').prop('disabled', true);
    $('#patient_address_map').hide();
  } else {
    district_options = $(districts).filter("optgroup[label='" + selected_province + "']").html();
    $('#patient_address_district').html(district_options).parent().show();
    selected_district = $(district_options).filter(":selected").html();
    if (selected_province === 'Guna Yala') {
      $('#patient_address_district').empty().prop('disabled', true);
    }
    corregimiento_options = $(corregimientos).filter("optgroup[label='" + selected_district + "']").html();
    $('#patient_address_corregimiento').html(corregimiento_options).parent().show();
  }
  $('#patient_address_province').change(function() {
    selected_province = $('#patient_address_province :selected').text();
    district_options = $(districts).filter("optgroup[label='" + selected_province + "']").prepend(blank_option).html();
    $('#patient_address_district').prop('disabled', false).html(district_options).val('').parent().show();
    $('#patient_address_map').show();
    updateMap(selected_province, '', '');
    if (selected_province === '') {
      $('#patient_address_district').empty().prop('disabled', true);
      $('#patient_address_corregimiento').empty().prop('disabled', true);
      $('#patient_address_line').val('').prop('disabled', true);
      $('#patient_address_map').hide();
    }
    if (selected_province === 'Guna Yala') {
      $('#patient_address_district').empty().prop('disabled', true);
      corregimiento_options = $(corregimientos).filter("optgroup[label='Guna Yala']").prepend(blank_option).html();
      return $('#patient_address_corregimiento').prop('disabled', false).html(corregimiento_options).val('').parent().show();
    } else {
      $('#patient_address_corregimiento').empty().prop('disabled', true);
      return $('#patient_address_line').prop('disabled', true);
    }
  });
  $('#patient_address_district').change(function() {
    $('#patient_address_district option[value=""]').remove();
    selected_district = $('#patient_address_district :selected').text();
    corregimiento_options = $(corregimientos).filter("optgroup[label='" + selected_district + "']").prepend(blank_option).html();
    $('#patient_address_corregimiento').prop('disabled', false).html(corregimiento_options).val('').parent().show();
    $('#patient_address_line').prop('disabled', true);
    return updateMap(selected_province, selected_district, '');
  });
  return $('#patient_address_corregimiento').change(function() {
    var selected_corregimiento;
    $('#patient_address_corregimiento option[value=""]').remove();
    selected_corregimiento = $('#patient_address_corregimiento :selected').text();
    $('#patient_address_line').prop('disabled', false);
    if (selected_province === 'Guna Yala') {
      selected_district = '';
    }
    return updateMap(selected_province, selected_district, selected_corregimiento);
  });
});

var updateMap = function(province, district, corregimiento) {
  return $('#patient_address_map').attr('href', 'https://www.google.com/maps/place/+' + corregimiento + '+' + district + '+' + province + '+Panamá');
};
