$(document).on 'change click', '.new_accession', ->
  panels = $('.panels').data('panel-ids')
  $('.panel').on 'change', ->
    panelId = $(this).find('input').val()
    toggleLabTests panelId, true

$(document).on 'change click', '.edit_accession', ->
  $('.panel').on 'change click', ->
    panelId = $(this).find('input').val()
    toggleLabTests panelId, false

$(document).on 'turbolinks:load change click', ->
  panels = $('.panels').data('panel-ids')
  if panels
    $.each panels, (index, panelId) ->
      if $('#accession_panel_ids_' + panelId).is(':checked')
        toggleLabTests panelId, false

toggleLabTests = (panelId, newAccession) ->
  labTests = $('#panel_' + panelId).data('lab-test-ids')
  if $('#accession_panel_ids_' + panelId).is(':checked')
    $.each labTests, (index, labTestId) ->
      $('#accession_lab_test_ids_' + labTestId).prop 'checked', true
      $('#accession_lab_test_ids_' + labTestId).prop 'disabled', true
  else
    $.each labTests, (index, labTestId) ->
      $('#accession_lab_test_ids_' + labTestId).prop 'disabled', false
      if newAccession
        $('#accession_lab_test_ids_' + labTestId).prop 'checked', false
  $('form').submit ->
    $('input').removeAttr 'disabled'
