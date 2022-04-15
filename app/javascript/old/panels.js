$(document).on('change click', '.new_accession', function() {
  var panels;
  panels = $('.panels').data('panel-ids');
  return $('.panel').on('change', function() {
    var panelId;
    panelId = $(this).find('input').val();
    return toggleLabTests(panelId, true);
  });
});

$(document).on('change click', '.edit_accession', function() {
  return $('.panel').on('change click', function() {
    var panelId;
    panelId = $(this).find('input').val();
    return toggleLabTests(panelId, false);
  });
});

$(document).on('turbo:load change click', function() {
  var panels;
  panels = $('.panels').data('panel-ids');
  if (panels) {
    return $.each(panels, function(index, panelId) {
      if ($('#accession_panel_ids_' + panelId).is(':checked')) {
        return toggleLabTests(panelId, false);
      }
    });
  }
});

var toggleLabTests = function(panelId, newAccession) {
  var labTests;
  labTests = $('#panel_' + panelId).data('lab-test-ids');
  if ($('#accession_panel_ids_' + panelId).is(':checked')) {
    $.each(labTests, function(index, labTestId) {
      $('#accession_lab_test_ids_' + labTestId).prop('checked', true);
      return $('#accession_lab_test_ids_' + labTestId).prop('disabled', true);
    });
  } else {
    $.each(labTests, function(index, labTestId) {
      $('#accession_lab_test_ids_' + labTestId).prop('disabled', false);
      if (newAccession) {
        return $('#accession_lab_test_ids_' + labTestId).prop('checked', false);
      }
    });
  }
  return $('form').submit(function() {
    return $('input').removeAttr('disabled');
  });
};
