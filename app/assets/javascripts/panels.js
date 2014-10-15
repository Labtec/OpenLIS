$(document).on("change click", ".new_accession", function() {
  var panels = $(".panels").data("panel-ids");

  $(".panel").on("change", function() {
    panelId = $(this).find("input").val();
    toggleLabTests(panelId, true);
  });
});

$(document).on("change click", ".edit_accession", function() {
  $(".panel").on("change", function() {
    panelId = $(this).find("input").val();
    toggleLabTests(panelId, false);
  });
});

$(document).on("ready page:load change click", function() {
  var panels = $(".panels").data("panel-ids");

  if (panels) {
    $.each(panels, function(index, panelId) {
      if ($("#accession_panel_ids_" + panelId).is(":checked")) {
        toggleLabTests(panelId, false);
      }
    });
  }
});

var toggleLabTests = function(panelId, newAccession) {
  var labTests = $("#panel_" + panelId).data("lab-test-ids");

  if ($("#accession_panel_ids_" + panelId).is(":checked")) {
    $.each(labTests, function(index, labTestId){
      $("#accession_lab_test_ids_" + labTestId).prop("checked", true);
      $("#accession_lab_test_ids_" + labTestId).prop("disabled", true);
    });
  } else {
    $.each(labTests, function(index, labTestId){
      $("#accession_lab_test_ids_" + labTestId).removeAttr("disabled");
      if (newAccession) {
        $("#accession_lab_test_ids_" + labTestId).removeAttr("checked");
      }
    });
  }

  $("#form").submit(function() {
    $("input").removeAttr("disabled");
    return true;
  });
};
