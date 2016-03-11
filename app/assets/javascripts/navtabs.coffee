$(document).on 'ready page:load', ->
  $tabs = $('#lab_tests').tabs()
  $panels = $('.ui-tabs-panel')
  $('#departments').tabs cache: true
  $('#departments').tabs 'paging',
    nextButton: '&rarr;'
    prevButton: '&larr;'
    follow: true
    followOnSelect: true
  $('#order_tests').tabs cache: true
  $('#order_tests').tabs 'paging',
    nextButton: '&rarr;'
    prevButton: '&larr;'
    follow: true
    followOnSelect: true
