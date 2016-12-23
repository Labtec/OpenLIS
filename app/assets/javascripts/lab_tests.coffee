$(document).on 'turbolinks:load', ->
  $('.lab_tests').sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.ajax
        type: 'patch'
        data: $('.lab_tests').sortable('serialize')
        dataType: 'script'
        complete: (request) ->
          $('.lab_tests').effect 'highlight'
        url: '/admin/lab_tests/sort'
