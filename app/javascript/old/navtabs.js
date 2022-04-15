$(document).on('turbo:load', function() {
  var $panels, $tabs;
  $tabs = $('#lab_tests').tabs();
  $panels = $('.ui-tabs-panel');
  $('#departments').tabs({
    cache: true
  });
  $('#departments').tabs('paging', {
    nextButton: '&rarr;',
    prevButton: '&larr;',
    follow: true,
    followOnSelect: true
  });
  $('#order_tests').tabs({
    cache: true
  });
  return $('#order_tests').tabs('paging', {
    nextButton: '&rarr;',
    prevButton: '&larr;',
    follow: true,
    followOnSelect: true
  });
});
