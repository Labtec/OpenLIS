startSpinner = function() {
  $("html").css("cursor", "progress");
};

stopSpinner = function() {
  $("html").css("cursor", "auto");
};

$(document).on("page:fetch", startSpinner);
$(document).on("page:receive", stopSpinner);
