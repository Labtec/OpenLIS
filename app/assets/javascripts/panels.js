$(function() {
  $.getScript(this.href);
  $("#panels").click(function() {
    $.getScript(this.href);
  });
});
