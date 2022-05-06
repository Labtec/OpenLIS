$(document).on('turbo:load turbo:render', function() {
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
