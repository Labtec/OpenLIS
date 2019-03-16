$(document).on 'turbolinks:load', ->
  $('.lab_tests').sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.ajax
        type: 'patch'
        data: $(this).sortable('serialize')
        dataType: 'script'
        complete: (request) ->
          $('.lab_tests').effect 'highlight'
        url: $(this).data('update-url')
